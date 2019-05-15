Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB9C1ECB9
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfEOLAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727516AbfEOLAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:00:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D53FC216FD;
        Wed, 15 May 2019 11:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918045;
        bh=JbHLyllfUeGtE6rI0Gy2Js2R5FpNhknPATPb1VufyeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0mnocl7hp+H4585BIOnubS8Rb4hr1c83zygAbiLoxD50gobGS+LSMvKre6CfiNkFH
         9CiEx8KBrGa77SJXnbcH05A8SF8zRBCqJ8xx3+GX54FH8lCpIS+sTaVUKGRHujoyoi
         GHE78eGlhckXYX/yQq59YHWJ3U6ldG46lGzT10bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 3.18 72/86] s390: ctcm: fix ctcm_new_device error return code
Date:   Wed, 15 May 2019 12:55:49 +0200
Message-Id: <20190515090655.137062236@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 27b141fc234a3670d21bd742c35d7205d03cbb3a ]

clang points out that the return code from this function is
undefined for one of the error paths:

../drivers/s390/net/ctcm_main.c:1595:7: warning: variable 'result' is used uninitialized whenever 'if' condition is true
      [-Wsometimes-uninitialized]
                if (priv->channel[direction] == NULL) {
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/s390/net/ctcm_main.c:1638:9: note: uninitialized use occurs here
        return result;
               ^~~~~~
../drivers/s390/net/ctcm_main.c:1595:3: note: remove the 'if' if its condition is always false
                if (priv->channel[direction] == NULL) {
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/s390/net/ctcm_main.c:1539:12: note: initialize the variable 'result' to silence this warning
        int result;
                  ^

Make it return -ENODEV here, as in the related failure cases.
gcc has a known bug in underreporting some of these warnings
when it has already eliminated the assignment of the return code
based on some earlier optimization step.

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ctcm_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index e056dd4fe44d1..5526388f905ec 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1595,6 +1595,7 @@ static int ctcm_new_device(struct ccwgroup_device *cgdev)
 		if (priv->channel[direction] == NULL) {
 			if (direction == CTCM_WRITE)
 				channel_free(priv->channel[CTCM_READ]);
+			result = -ENODEV;
 			goto out_dev;
 		}
 		priv->channel[direction]->netdev = dev;
-- 
2.20.1



