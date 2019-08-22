Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D6399B55
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391640AbfHVRXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391482AbfHVRWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:47 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65A7A233FE;
        Thu, 22 Aug 2019 17:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494566;
        bh=M0ON+wcSMXQ4IP2Gj/v1u/IHC14XFEaaHkW20mRRtX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqw0aEEyNZzHtCEItJsDsE6dwvibKWPSIwntvhS/K7NUrHQKao6Yp7ExnmcYgyv0G
         a3SqczWBE443ghsSqW58FRVF7K0zgmAh8JLXIaMrzPXiAmf8lcWlpmC/lEPiR0jneW
         HTab9ydMUfqsyOKVVqCPcHQqge2iAztvVhnSJNhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Binderman <dcb314@hotmail.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.4 55/78] staging: comedi: dt3000: Fix signed integer overflow divider * base
Date:   Thu, 22 Aug 2019 10:18:59 -0700
Message-Id: <20190822171833.633945478@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
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
@@ -377,7 +377,7 @@ static int dt3k_ns_to_timer(unsigned int
 	}
 
 	prescale = 15;
-	base = timer_base * (1 << prescale);
+	base = timer_base * (prescale + 1);
 	divider = 65535;
 	*nanosec = divider * base;
 	return (prescale << 16) | (divider);


