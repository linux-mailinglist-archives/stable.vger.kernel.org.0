Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A15A76994
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387655AbfGZNwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388276AbfGZNnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:43:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2C8B22CD2;
        Fri, 26 Jul 2019 13:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148619;
        bh=gsuoE7DbAik0ijegEYtv7fBl6Wx9stFEydQyonDyRT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nafqbX1gWZhKY01WNY6cZGh2ZSOP02USSTA4opBFEnx5BPf6M4JsGoEe0Co5hLD09
         ajMbRCGhPSIPQfH5emZrc85eAFH6K8hNy+bq+18dkJrxESNJdnN6LWX5jnvmnE1PVm
         hNTdUUpHO86OxZV6FCozeEB18rqZmRQrZNeH4MlE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prarit Bhargava <prarit@redhat.com>,
        Barret Rhoden <brho@google.com>,
        David Arcari <darcari@redhat.com>,
        Jessica Yu <jeyu@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 06/37] kernel/module.c: Only return -EEXIST for modules that have finished loading
Date:   Fri, 26 Jul 2019 09:43:01 -0400
Message-Id: <20190726134332.12626-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134332.12626-1-sashal@kernel.org>
References: <20190726134332.12626-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prarit Bhargava <prarit@redhat.com>

[ Upstream commit 6e6de3dee51a439f76eb73c22ae2ffd2c9384712 ]

Microsoft HyperV disables the X86_FEATURE_SMCA bit on AMD systems, and
linux guests boot with repeated errors:

amd64_edac_mod: Unknown symbol amd_unregister_ecc_decoder (err -2)
amd64_edac_mod: Unknown symbol amd_register_ecc_decoder (err -2)
amd64_edac_mod: Unknown symbol amd_report_gart_errors (err -2)
amd64_edac_mod: Unknown symbol amd_unregister_ecc_decoder (err -2)
amd64_edac_mod: Unknown symbol amd_register_ecc_decoder (err -2)
amd64_edac_mod: Unknown symbol amd_report_gart_errors (err -2)

The warnings occur because the module code erroneously returns -EEXIST
for modules that have failed to load and are in the process of being
removed from the module list.

module amd64_edac_mod has a dependency on module edac_mce_amd.  Using
modules.dep, systemd will load edac_mce_amd for every request of
amd64_edac_mod.  When the edac_mce_amd module loads, the module has
state MODULE_STATE_UNFORMED and once the module load fails and the state
becomes MODULE_STATE_GOING.  Another request for edac_mce_amd module
executes and add_unformed_module() will erroneously return -EEXIST even
though the previous instance of edac_mce_amd has MODULE_STATE_GOING.
Upon receiving -EEXIST, systemd attempts to load amd64_edac_mod, which
fails because of unknown symbols from edac_mce_amd.

add_unformed_module() must wait to return for any case other than
MODULE_STATE_LIVE to prevent a race between multiple loads of
dependent modules.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Barret Rhoden <brho@google.com>
Cc: David Arcari <darcari@redhat.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 94528b891027..4b372c14d9a1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3391,8 +3391,7 @@ static bool finished_loading(const char *name)
 	sched_annotate_sleep();
 	mutex_lock(&module_mutex);
 	mod = find_module_all(name, strlen(name), true);
-	ret = !mod || mod->state == MODULE_STATE_LIVE
-		|| mod->state == MODULE_STATE_GOING;
+	ret = !mod || mod->state == MODULE_STATE_LIVE;
 	mutex_unlock(&module_mutex);
 
 	return ret;
@@ -3560,8 +3559,7 @@ static int add_unformed_module(struct module *mod)
 	mutex_lock(&module_mutex);
 	old = find_module_all(mod->name, strlen(mod->name), true);
 	if (old != NULL) {
-		if (old->state == MODULE_STATE_COMING
-		    || old->state == MODULE_STATE_UNFORMED) {
+		if (old->state != MODULE_STATE_LIVE) {
 			/* Wait in case it fails to load. */
 			mutex_unlock(&module_mutex);
 			err = wait_event_interruptible(module_wq,
-- 
2.20.1

