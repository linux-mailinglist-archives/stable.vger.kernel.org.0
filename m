Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5685181ACF
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbfHENJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730196AbfHENJa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:09:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE4F92067D;
        Mon,  5 Aug 2019 13:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010569;
        bh=ZSBmUrMshud0WeYJVIQm7+RxMhXoN3hNrG3XuphpSVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ek3KPvhs802tc9c+iTIlnRmeJZ1cVQIbOA+VWDdjgve5GmUKjXLJ0zxQmbcIlkH9s
         r+X9BeEsnu3eOolCfBAmA12g/qJgrOFG8iHFw69B9BMc6shNsDYqeAHnL9aqCeObUL
         xZHBFhbZJZX/OnAfFlwRMS4LgYZvcs1bQvKNtu6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Barret Rhoden <brho@google.com>,
        David Arcari <darcari@redhat.com>,
        Jessica Yu <jeyu@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/74] kernel/module.c: Only return -EEXIST for modules that have finished loading
Date:   Mon,  5 Aug 2019 15:02:21 +0200
Message-Id: <20190805124936.480073001@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index b8f37376856bd..3fda10c549a25 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3388,8 +3388,7 @@ static bool finished_loading(const char *name)
 	sched_annotate_sleep();
 	mutex_lock(&module_mutex);
 	mod = find_module_all(name, strlen(name), true);
-	ret = !mod || mod->state == MODULE_STATE_LIVE
-		|| mod->state == MODULE_STATE_GOING;
+	ret = !mod || mod->state == MODULE_STATE_LIVE;
 	mutex_unlock(&module_mutex);
 
 	return ret;
@@ -3559,8 +3558,7 @@ again:
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



