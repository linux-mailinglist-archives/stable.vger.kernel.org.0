Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EADC6353A5
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbiKWI5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbiKWI5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:57:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE4DFFA8F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:57:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AE426CE20F0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D54C433D6;
        Wed, 23 Nov 2022 08:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193821;
        bh=J7f2eiBKoZJCoQOpthwgg0o1eMVVWUdeihF2VM5cFP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hj4xS1JC/D5Xd792zfphC/G/8gnMsVMtqk2ggoc/cZnOsTAvH65auxjdUok3Mzghb
         7k4gT4aKwOYO7npTJ6gQ4d6gOyzvIe44NsVU1lybquQIFkgCphFMOo6EwB6zrxGBBn
         SmwSX/Dq4oSGDRIMTzFVnvF3qMTTF085Uj/elPSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 4.9 71/76] gfs2: Switch from strlcpy to strscpy
Date:   Wed, 23 Nov 2022 09:51:10 +0100
Message-Id: <20221123084549.076057260@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 204c0300c4e99707e9fb6e57840aa1127060e63f upstream.

Switch from strlcpy to strscpy and make sure that @count is the size of
the smaller of the source and destination buffers.  This prevents
reading beyond the end of the source buffer when the source string isn't
null terminated.

Found by a modified version of syzkaller.

Suggested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/ops_fstype.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -390,8 +390,10 @@ static int init_names(struct gfs2_sbd *s
 	if (!table[0])
 		table = sdp->sd_vfs->s_id;
 
-	strlcpy(sdp->sd_proto_name, proto, GFS2_FSNAME_LEN);
-	strlcpy(sdp->sd_table_name, table, GFS2_FSNAME_LEN);
+	BUILD_BUG_ON(GFS2_LOCKNAME_LEN > GFS2_FSNAME_LEN);
+
+	strscpy(sdp->sd_proto_name, proto, GFS2_LOCKNAME_LEN);
+	strscpy(sdp->sd_table_name, table, GFS2_LOCKNAME_LEN);
 
 	table = sdp->sd_table_name;
 	while ((table = strchr(table, '/')))


