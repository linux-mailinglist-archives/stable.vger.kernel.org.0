Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA2A561D0C
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbiF3OKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbiF3OIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:08:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9C473914;
        Thu, 30 Jun 2022 06:55:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 822E8B82AD8;
        Thu, 30 Jun 2022 13:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D37C34115;
        Thu, 30 Jun 2022 13:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597306;
        bh=wh1pKIla8PGTcAVta3KyOdpbg5zeT/YauvyFaMXt3aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxVZDqBc/byCsY96c+8AnMlM0pxvoKLR6lkh+UhZqE1zngHVPAVSc4koMqcD2pz0f
         WY4bYAGfTLxoC22LuLoJC/sk91CF3VOMc91QCxVVtU1H2S/wx3UqWN0GtEoO7MamqD
         CnWmd2VcXOh8evgaRCQulJ9+JFRErPOSxQn7d2UU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seth Forshee <sforshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>
Subject: [PATCH 5.15 15/28] fs: tweak fsuidgid_has_mapping()
Date:   Thu, 30 Jun 2022 15:47:11 +0200
Message-Id: <20220630133233.376413710@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 476860b3eb4a50958243158861d5340066df5af2 upstream.

If the caller's fs{g,u}id aren't mapped in the mount's idmapping we can
return early and skip the check whether the mapped fs{g,u}id also have a
mapping in the filesystem's idmapping. If the fs{g,u}id aren't mapped in
the mount's idmapping they consequently can't be mapped in the
filesystem's idmapping. So there's no point in checking that.

Link: https://lore.kernel.org/r/20211123114227.3124056-4-brauner@kernel.org (v1)
Link: https://lore.kernel.org/r/20211130121032.3753852-4-brauner@kernel.org (v2)
Link: https://lore.kernel.org/r/20211203111707.3901969-4-brauner@kernel.org
Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1697,10 +1697,18 @@ static inline void inode_fsgid_set(struc
 static inline bool fsuidgid_has_mapping(struct super_block *sb,
 					struct user_namespace *mnt_userns)
 {
-	struct user_namespace *s_user_ns = sb->s_user_ns;
+	struct user_namespace *fs_userns = sb->s_user_ns;
+	kuid_t kuid;
+	kgid_t kgid;
 
-	return kuid_has_mapping(s_user_ns, mapped_fsuid(mnt_userns)) &&
-	       kgid_has_mapping(s_user_ns, mapped_fsgid(mnt_userns));
+	kuid = mapped_fsuid(mnt_userns);
+	if (!uid_valid(kuid))
+		return false;
+	kgid = mapped_fsgid(mnt_userns);
+	if (!gid_valid(kgid))
+		return false;
+	return kuid_has_mapping(fs_userns, kuid) &&
+	       kgid_has_mapping(fs_userns, kgid);
 }
 
 extern struct timespec64 current_time(struct inode *inode);


