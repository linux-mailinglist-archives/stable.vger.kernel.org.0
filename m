Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7DC799C1A
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389667AbfHVRbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404534AbfHVRZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:56 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A79A52342B;
        Thu, 22 Aug 2019 17:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494755;
        bh=dj7mEkG4videPuN9hCV/MWfKJniVmyHGSAILoiUiZLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijfkt63oRWWACijW6697/D9l7LVsKcN0Ii0pOa2FdnPSdhd8cZxD1HAOJqF1LNsNQ
         D5Md/WIp4Q2V9vQat/EmZn7aovuXl/0T9Iqr8547kOQrHYJj8jecLp+lEahFBt+2Ho
         2w85P0OVMC65osWAQ0LMQXjfTaWGohln0zYYS8hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Binderman <dcb314@hotmail.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.19 56/85] staging: comedi: dt3000: Fix signed integer overflow divider * base
Date:   Thu, 22 Aug 2019 10:19:29 -0700
Message-Id: <20190822171733.646826894@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

commit b4d98bc3fc93ec3a58459948a2c0e0c9b501cd88 upstream.

In `dt3k_ns_to_timer()` the following lines near the end of the function
result in a signed integer overflow:

	prescale = 15;
	base = timer_base * (1 << prescale);
	divider = 65535;
	*nanosec = divider * base;

(`divider`, `base` and `prescale` are type `int`, `timer_base` and
`*nanosec` are type `unsigned int`.  The value of `timer_base` will be
either 50 or 100.)

The main reason for the overflow is that the calculation for `base` is
completely wrong.  It should be:

	base = timer_base * (prescale + 1);

which matches an earlier instance of this calculation in the same
function.

Reported-by: David Binderman <dcb314@hotmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20190812111517.26803-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/dt3000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -368,7 +368,7 @@ static int dt3k_ns_to_timer(unsigned int
 	}
 
 	prescale = 15;
-	base = timer_base * (1 << prescale);
+	base = timer_base * (prescale + 1);
 	divider = 65535;
 	*nanosec = divider * base;
 	return (prescale << 16) | (divider);


