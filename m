Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABF437C113
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbhELO43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231614AbhELOzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:55:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72F6461422;
        Wed, 12 May 2021 14:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831256;
        bh=NLXEKaOndNZMQn/a5Q5Dr7TZQmZTbkyOVM5SrDvo280=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeCXYky8AouMHpNUwR+nZsFCQFe42ndWirNdjG18lDoG5WUcF2wgtzh7LlCqqHLqm
         h5ac8LfQOugjYSRX1RQe8iSar4DV43PqdsSbOo3byWWLkEiD7X0q9pa+59PSeAxEiJ
         wwWS32+BHque2mGOZ26rmcH334Drs8xaFHTNk8f4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 011/244] staging: fwserial: fix TIOCSSERIAL jiffies conversions
Date:   Wed, 12 May 2021 16:46:22 +0200
Message-Id: <20210512144743.405431226@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 7a3791afdbd5a951b09a7689bba856bd9f6c6a9f upstream.

The port close_delay parameter set by TIOCSSERIAL is specified in
jiffies, while the value returned by TIOCGSERIAL is specified in
centiseconds.

Add the missing conversions so that TIOCGSERIAL works as expected also
when HZ is not 100.

Fixes: 7355ba3445f2 ("staging: fwserial: Add TTY-over-Firewire serial driver")
Cc: stable@vger.kernel.org      # 3.8
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/fwserial/fwserial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1223,7 +1223,7 @@ static int get_serial_info(struct tty_st
 	ss->flags = port->port.flags;
 	ss->xmit_fifo_size = FWTTY_PORT_TXFIFO_LEN;
 	ss->baud_base = 400000000;
-	ss->close_delay = port->port.close_delay;
+	ss->close_delay = jiffies_to_msecs(port->port.close_delay) / 10;
 	mutex_unlock(&port->port.mutex);
 	return 0;
 }
@@ -1245,7 +1245,7 @@ static int set_serial_info(struct tty_st
 			return -EPERM;
 		}
 	}
-	port->port.close_delay = ss->close_delay * HZ / 100;
+	port->port.close_delay = msecs_to_jiffies(ss->close_delay * 10);
 	mutex_unlock(&port->port.mutex);
 
 	return 0;


