Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8C13820A5
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 21:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhEPT3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 15:29:04 -0400
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21339 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhEPT3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 15:29:04 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621193252; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=GpTODC/DLEfsPiaz5f0uHe14TK/B7PCR6E2MSep8ov0URKYeSoEyibrf+uLFV4b9tqtfLmX7iA7r1M7Vy0aSvH6+2CMmi++xAk4rUr9HLKv3FKsa5X8O1ggjlF2f9P7H9nfB2JWtIhvRv6pvxuV9x9Oa8maV2T9axI6xCi6kkHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1621193252; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=kcMsIBb4mr1nm3LmQ5wyFHGYyNEsGyNz7p4rtiGeyZw=; 
        b=ebmZ0BvljHKpi8/DOujECR5AqX0ciAlFM9R6cmX/xRDHAj6xXR2NzNoQ2pu35XolsRZ5n9UPJhUXv7H3DTZfqoAumH5MmtYzaa0S8eVYfrN82HFYWV6j13EigW/HOWjU7LtCFooji08pSwiMhO8hPlURpCQIwiOo/7XYGwxw8SY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com> header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1621193252;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=kcMsIBb4mr1nm3LmQ5wyFHGYyNEsGyNz7p4rtiGeyZw=;
        b=yKN+eYUKedxDvM/J8PgnoWdA/PYpQ/ssg6uNKVFtcUdxu+VXHAUmoJdfB3NBMyqz
        mHDG/qCeHPOlI2IKSwASWbtWhWj7QOrSwjxUfhx/r80gP3eQWaxm8WJtqIlNis6xvqo
        /birjyRZtdje8eIcI1A0jppl2fvCvnj1ZNEm0p8g=
Received: from localhost.localdomain (106.51.110.61 [106.51.110.61]) by mx.zohomail.com
        with SMTPS id 1621193251338853.0225315553987; Sun, 16 May 2021 12:27:31 -0700 (PDT)
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Igor Matheus Andrade Torrente <igormtorrente@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        kernel test robot <oliver.sang@intel.com>,
        stable <stable@vger.kernel.org>,
        linux-nvidia@lists.surfsouth.com, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: hgafb: correctly handle card detect failure during probe
Date:   Mon, 17 May 2021 00:57:14 +0530
Message-Id: <20210516192714.25823-1-mail@anirudhrb.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The return value of hga_card_detect() is not properly handled causing
the probe to succeed even though hga_card_detect() failed. Since probe
succeeds, hgafb_open() can be called which will end up operating on an
unmapped hga_vram. This results in an out-of-bounds access as reported
by kernel test robot [1].

To fix this, correctly detect failure of hga_card_detect() by checking
for a non-zero error code.

[1]: https://lore.kernel.org/lkml/20210516150019.GB25903@xsang-OptiPlex-9020/

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: dc13cac4862c ("video: hgafb: fix potential NULL pointer dereference")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
---
 drivers/video/fbdev/hgafb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
index cc8e62ae93f6..bd3d07aa4f0e 100644
--- a/drivers/video/fbdev/hgafb.c
+++ b/drivers/video/fbdev/hgafb.c
@@ -558,7 +558,7 @@ static int hgafb_probe(struct platform_device *pdev)
 	int ret;
 
 	ret = hga_card_detect();
-	if (!ret)
+	if (ret)
 		return ret;
 
 	printk(KERN_INFO "hgafb: %s with %ldK of memory detected.\n",
-- 
2.26.2

