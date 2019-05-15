Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4881F06C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbfEOLoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:44:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730025AbfEOL0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:26:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E9CB206BF;
        Wed, 15 May 2019 11:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919609;
        bh=M1A+x2isSaTGTVAoH+Dy0WZMUUpWQu43cxkqdxAixws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIHYYSHhR3HAOhEiIEynNFMKyS98eVIzCfnuM3AIOu5VWriTJkDPkcys7yFhrVrOE
         GoCI32IhbXNKeUDTf46eFEIkJ4L3CmHt4+MXHPzDucc5GtBNRCcv//1naD/rL1cF19
         fUrFQXw0MP8cTbp+58n83kAMwbuEpdCKIGHZnrsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 026/137] libnvdimm/security: provide fix for secure-erase to use zero-key
Date:   Wed, 15 May 2019 12:55:07 +0200
Message-Id: <20190515090655.178173486@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 037c8489ade669e0f09ad40d5b91e5e1159a14b1 ]

Add a zero key in order to standardize hardware that want a key of 0's to
be passed. Some platforms defaults to a zero-key with security enabled
rather than allow the OS to enable the security. The zero key would allow
us to manage those platform as well. This also adds a fix to secure erase
so it can use the zero key to do crypto erase. Some other security commands
already use zero keys. This introduces a standard zero-key to allow
unification of semantics cross nvdimm security commands.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/security.c        | 17 ++++++++++++-----
 tools/testing/nvdimm/test/nfit.c | 11 +++++++++--
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index f8bb746a549f7..6bea6852bf278 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -22,6 +22,8 @@ static bool key_revalidate = true;
 module_param(key_revalidate, bool, 0444);
 MODULE_PARM_DESC(key_revalidate, "Require key validation at init.");
 
+static const char zero_key[NVDIMM_PASSPHRASE_LEN];
+
 static void *key_data(struct key *key)
 {
 	struct encrypted_key_payload *epayload = dereference_key_locked(key);
@@ -286,8 +288,9 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
 {
 	struct device *dev = &nvdimm->dev;
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
-	struct key *key;
+	struct key *key = NULL;
 	int rc;
+	const void *data;
 
 	/* The bus lock should be held at the top level of the call stack */
 	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
@@ -319,11 +322,15 @@ int nvdimm_security_erase(struct nvdimm *nvdimm, unsigned int keyid,
 		return -EOPNOTSUPP;
 	}
 
-	key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
-	if (!key)
-		return -ENOKEY;
+	if (keyid != 0) {
+		key = nvdimm_lookup_user_key(nvdimm, keyid, NVDIMM_BASE_KEY);
+		if (!key)
+			return -ENOKEY;
+		data = key_data(key);
+	} else
+		data = zero_key;
 
-	rc = nvdimm->sec.ops->erase(nvdimm, key_data(key), pass_type);
+	rc = nvdimm->sec.ops->erase(nvdimm, data, pass_type);
 	dev_dbg(dev, "key: %d erase%s: %s\n", key_serial(key),
 			pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
 			rc == 0 ? "success" : "fail");
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index b579f962451d6..cad719876ef45 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -225,6 +225,8 @@ static struct workqueue_struct *nfit_wq;
 
 static struct gen_pool *nfit_pool;
 
+static const char zero_key[NVDIMM_PASSPHRASE_LEN];
+
 static struct nfit_test *to_nfit_test(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -1059,8 +1061,7 @@ static int nd_intel_test_cmd_secure_erase(struct nfit_test *t,
 	struct device *dev = &t->pdev.dev;
 	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
 
-	if (!(sec->state & ND_INTEL_SEC_STATE_ENABLED) ||
-			(sec->state & ND_INTEL_SEC_STATE_FROZEN)) {
+	if (sec->state & ND_INTEL_SEC_STATE_FROZEN) {
 		nd_cmd->status = ND_INTEL_STATUS_INVALID_STATE;
 		dev_dbg(dev, "secure erase: wrong security state\n");
 	} else if (memcmp(nd_cmd->passphrase, sec->passphrase,
@@ -1068,6 +1069,12 @@ static int nd_intel_test_cmd_secure_erase(struct nfit_test *t,
 		nd_cmd->status = ND_INTEL_STATUS_INVALID_PASS;
 		dev_dbg(dev, "secure erase: wrong passphrase\n");
 	} else {
+		if (!(sec->state & ND_INTEL_SEC_STATE_ENABLED)
+				&& (memcmp(nd_cmd->passphrase, zero_key,
+					ND_INTEL_PASSPHRASE_SIZE) != 0)) {
+			dev_dbg(dev, "invalid zero key\n");
+			return 0;
+		}
 		memset(sec->passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
 		memset(sec->master_passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
 		sec->state = 0;
-- 
2.20.1



