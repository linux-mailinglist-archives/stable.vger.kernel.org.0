Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542C2490F17
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238796AbiAQRP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243145AbiAQRMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:12:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DE3C0612DF;
        Mon, 17 Jan 2022 09:07:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6945611F1;
        Mon, 17 Jan 2022 17:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B45C36AEC;
        Mon, 17 Jan 2022 17:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439260;
        bh=sySPTNdEhcF7C94lJKAfucfeS/5lj3Mr/SaXWyQkuJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+SxTUkQC4yDtq5/3jYQH4gga/7us+WFohVIhdoqJuYwOAKPy+LAO8A4CCe+SNf0D
         v/IFUrUXQjqtEvqtbTZKfKCf+4gwBNYQ8BnVllsc7cWNvvPBM444ziLqCUEIeyacYX
         IJmNhnSoSxim930ZsZmBLrm3A1h/XLWUOS1y3PU7b/mqlOT2cm7pdRDOWjIHMohGEf
         S++XTETLXqdxdY66SNV7KtsgXiHzrRglF4tY/o4LqBSedvigyxWfcTVM8nd/lfmvT1
         pF9/J1V0Hr0Webj9nqu44Lzej6i2BbEXCScmEK8yPaW8d/bn/UA3aI3aQNaEizTriQ
         u1TUeEBW8Nlbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        kernel test robot <lkp@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, zbr@ioremap.net
Subject: [PATCH AUTOSEL 4.9 08/13] w1: Misuse of get_user()/put_user() reported by sparse
Date:   Mon, 17 Jan 2022 12:07:16 -0500
Message-Id: <20220117170722.1473137-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170722.1473137-1-sashal@kernel.org>
References: <20220117170722.1473137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 33dc3e3e99e626ce51f462d883b05856c6c30b1d ]

sparse warnings: (new ones prefixed by >>)
>> drivers/w1/slaves/w1_ds28e04.c:342:13: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected char [noderef] __user *_pu_addr @@     got char *buf @@
   drivers/w1/slaves/w1_ds28e04.c:342:13: sparse:     expected char [noderef] __user *_pu_addr
   drivers/w1/slaves/w1_ds28e04.c:342:13: sparse:     got char *buf
>> drivers/w1/slaves/w1_ds28e04.c:356:13: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected char const [noderef] __user *_gu_addr @@     got char const *buf @@
   drivers/w1/slaves/w1_ds28e04.c:356:13: sparse:     expected char const [noderef] __user *_gu_addr
   drivers/w1/slaves/w1_ds28e04.c:356:13: sparse:     got char const *buf

The buffer buf is a failsafe buffer in kernel space, it's not user
memory hence doesn't deserve the use of get_user() or put_user().

Access 'buf' content directly.

Link: https://lore.kernel.org/lkml/202111190526.K5vb7NWC-lkp@intel.com/T/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/d14ed8d71ad4372e6839ae427f91441d3ba0e94d.1637946316.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/slaves/w1_ds28e04.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds28e04.c b/drivers/w1/slaves/w1_ds28e04.c
index 5e348d38ec5c9..f4cf54c256fd8 100644
--- a/drivers/w1/slaves/w1_ds28e04.c
+++ b/drivers/w1/slaves/w1_ds28e04.c
@@ -39,7 +39,7 @@ static int w1_strong_pullup = 1;
 module_param_named(strong_pullup, w1_strong_pullup, int, 0);
 
 /* enable/disable CRC checking on DS28E04-100 memory accesses */
-static char w1_enable_crccheck = 1;
+static bool w1_enable_crccheck = true;
 
 #define W1_EEPROM_SIZE		512
 #define W1_PAGE_COUNT		16
@@ -346,32 +346,18 @@ static BIN_ATTR_RW(pio, 1);
 static ssize_t crccheck_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
-	if (put_user(w1_enable_crccheck + 0x30, buf))
-		return -EFAULT;
-
-	return sizeof(w1_enable_crccheck);
+	return sysfs_emit(buf, "%d\n", w1_enable_crccheck);
 }
 
 static ssize_t crccheck_store(struct device *dev, struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
-	char val;
-
-	if (count != 1 || !buf)
-		return -EINVAL;
+	int err = kstrtobool(buf, &w1_enable_crccheck);
 
-	if (get_user(val, buf))
-		return -EFAULT;
+	if (err)
+		return err;
 
-	/* convert to decimal */
-	val = val - 0x30;
-	if (val != 0 && val != 1)
-		return -EINVAL;
-
-	/* set the new value */
-	w1_enable_crccheck = val;
-
-	return sizeof(w1_enable_crccheck);
+	return count;
 }
 
 static DEVICE_ATTR_RW(crccheck);
-- 
2.34.1

