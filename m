Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D36465D8F0
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239977AbjADQUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239991AbjADQT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:19:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F47E3E0E9
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:19:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 174A0B81731
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58544C433D2;
        Wed,  4 Jan 2023 16:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849195;
        bh=fzNwxn+5D9l4ObhjrXek79HPmvYNmES/HeGoYcrd520=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HH4SLtGtaEBmONWQc5mAgZjagUbstJTStvMcOIGBhvQmyymfpzniJZDFbtiwR4sPC
         BYXW9g0PIFANF2xSCDAcdm72zSrNVgqs62klfBSVCRugZRPX3ZTl7s2CIq041Mbl1O
         SJ0W3AlYkWki/X5sghXJOYw6oHhXGR6Gmo7P9JhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 081/177] cifs: fix missing display of three mount options
Date:   Wed,  4 Jan 2023 17:06:12 +0100
Message-Id: <20230104160510.104715262@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

commit 2bfd81043e944af0e52835ef6d9b41795af22341 upstream.

Three mount options: "tcpnodelay" and "noautotune" and "noblocksend"
were not displayed when passed in on cifs/smb3 mounts (e.g. displayed
in /proc/mounts e.g.).  No change to defaults so these are not
displayed if not specified on mount.

Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -678,9 +678,15 @@ cifs_show_options(struct seq_file *s, st
 	seq_printf(s, ",echo_interval=%lu",
 			tcon->ses->server->echo_interval / HZ);
 
-	/* Only display max_credits if it was overridden on mount */
+	/* Only display the following if overridden on mount */
 	if (tcon->ses->server->max_credits != SMB2_MAX_CREDITS_AVAILABLE)
 		seq_printf(s, ",max_credits=%u", tcon->ses->server->max_credits);
+	if (tcon->ses->server->tcp_nodelay)
+		seq_puts(s, ",tcpnodelay");
+	if (tcon->ses->server->noautotune)
+		seq_puts(s, ",noautotune");
+	if (tcon->ses->server->noblocksnd)
+		seq_puts(s, ",noblocksend");
 
 	if (tcon->snapshot_time)
 		seq_printf(s, ",snapshot=%llu", tcon->snapshot_time);


