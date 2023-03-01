Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750056A708C
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjCAQH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjCAQHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:07:54 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A2D192
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 08:07:51 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5015321AA5;
        Wed,  1 Mar 2023 16:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677686870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Kdi6zctTG29VP7go0XhIdHEXV0Bg4j60NjAzu8YoBuQ=;
        b=D5thmDMsEGBHdEhY0SrJUMQZ4mg1qGEsuoEgiQh9nyRhEAtT8seMYtRK2JvzgL5a+yhOPI
        AZjnwjmdHIP4HLp1jz35QbvekeXJg5kJT1xgpnJD3Xs/vhamDZqTJwxbkF7ewjGH8KO03V
        +zMweIg02JPJe+g6+oha3Qhrc4QDLpo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677686870;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Kdi6zctTG29VP7go0XhIdHEXV0Bg4j60NjAzu8YoBuQ=;
        b=wZS86/BPsynFyeihQe1l47MLZrQH1Gmqnhn4aBquQ3roNBaN4E3s/oAcDzKNCs0MTMR5WW
        s+aQ+GhPoJYGxgAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 110F013A3E;
        Wed,  1 Mar 2023 16:07:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id K/0vA1Z4/2OqcwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 01 Mar 2023 16:07:50 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     zackr@vmware.com, linux-graphics-maintainer@vmware.com,
        airlied@gmail.com, daniel@ffwll.ch
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
Subject: [PATCH] drm/vmwgfx: Avoid NULL-ptr dereference in vmw_cmd_dx_define_query()
Date:   Wed,  1 Mar 2023 17:07:48 +0100
Message-Id: <20230301160748.20775-1-tzimmermann@suse.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There have been reports [1][2] that vmw_cmd_dx_define_query() can
be called with ctx_node->ctx set to NULL, which results in undefined
behavior in vmw_context_cotable(). Avoid this be returning an errno
code.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://www.cve.org/CVERecord?id=CVE-2022-38096 # 1
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2073 # 2
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 6b9aa2b4ef54..1e90362add96 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1256,7 +1256,7 @@ static int vmw_cmd_dx_define_query(struct vmw_private *dev_priv,
 	struct vmw_resource *cotable_res;
 	int ret;
 
-	if (!ctx_node)
+	if (!ctx_node || !ctx_node->ctx)
 		return -EINVAL;
 
 	cmd = container_of(header, typeof(*cmd), header);
-- 
2.39.2

