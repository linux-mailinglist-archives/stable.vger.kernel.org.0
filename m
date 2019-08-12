Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D9789C7E
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 13:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfHLLVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 07:21:43 -0400
Received: from smtp123.iad3b.emailsrvr.com ([146.20.161.123]:45451 "EHLO
        smtp123.iad3b.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727995AbfHLLVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 07:21:43 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Aug 2019 07:21:42 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1565608532;
        bh=9x1cUfvsbcEgha7aQEB/fsAOqNVDRg4jX3S5Aq1JnlM=;
        h=From:To:Subject:Date:From;
        b=MPY+5qIxeWtB1AUiHhqiIg3YKJOkgBPozzz0gTtblWwpT/ZtRLIyrMLuJGcAWaD33
         +2jSzeoCASSZSqRNDFIZyycDXW6WnjylIgQw8W+aRTKMe/aDFMkzaMBhUVG0ZwUmPJ
         5ievljPv9nFGMG/n9BqnX/Pp7GtUtIZAtVOsOtw4=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp16.relay.iad3b.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 3A861C00BC;
        Mon, 12 Aug 2019 07:15:31 -0400 (EDT)
X-Sender-Id: abbotti@mev.co.uk
Received: from ian-deb.inside.mev.co.uk (remote.quintadena.com [81.133.34.160])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256)
        by 0.0.0.0:465 (trex/5.7.12);
        Mon, 12 Aug 2019 07:15:32 -0400
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-kernel@vger.kernel.org, David Binderman <dcb314@hotmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] staging: comedi: dt3000: Fix signed integer overflow 'divider * base'
Date:   Mon, 12 Aug 2019 12:15:17 +0100
Message-Id: <20190812111517.26803-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
N.B. Greg: The original report suggested an actual build error, so
may be prudent to queue this on your 'staging-linus' queue.

 drivers/staging/comedi/drivers/dt3000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 2edf3ee91300..4ad176fc14ad 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -368,7 +368,7 @@ static int dt3k_ns_to_timer(unsigned int timer_base, unsigned int *nanosec,
 	}
 
 	prescale = 15;
-	base = timer_base * (1 << prescale);
+	base = timer_base * (prescale + 1);
 	divider = 65535;
 	*nanosec = divider * base;
 	return (prescale << 16) | (divider);
-- 
2.20.1

