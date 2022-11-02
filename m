Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28A6615951
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiKBDJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiKBDIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:08:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1975A6176
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:08:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACFAF61799
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5658FC433C1;
        Wed,  2 Nov 2022 03:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358503;
        bh=X8PNpVJB6bNxEWOeHKWlcWHKiAf1Yn2B94kY+ELPH80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSJZiBY7hZgis+isE69JkO94WX/NvsH3fnIyh+DI1GWWrfkQhyLM6NXOIGeG33XK6
         jIIDo78ENEtWdDRbaETDjM3bikGMog6RJS6UAxoYioyYcSc+cWW/nDNEbWfQ9hSZ3F
         QFT8KgrUE0CPyGnlFb837fLWniqaoo1q4h+Dxc7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+31cde0bef4bbf8ba2d86@syzkaller.appspotmail.com,
        Thomas Graf <tgraf@suug.ch>, Aaron Conole <aconole@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/132] openvswitch: switch from WARN to pr_warn
Date:   Wed,  2 Nov 2022 03:33:36 +0100
Message-Id: <20221102022102.558364631@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Conole <aconole@redhat.com>

[ Upstream commit fd954cc1919e35cb92f78671cab6e42d661945a3 ]

As noted by Paolo Abeni, pr_warn doesn't generate any splat and can still
preserve the warning to the user that feature downgrade occurred.  We
likely cannot introduce other kinds of checks / enforcement here because
syzbot can generate different genl versions to the datapath.

Reported-by: syzbot+31cde0bef4bbf8ba2d86@syzkaller.appspotmail.com
Fixes: 44da5ae5fbea ("openvswitch: Drop user features if old user space attempted to create datapath")
Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Aaron Conole <aconole@redhat.com>
Acked-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 46ef1525b2e5..94c48122fdc3 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1605,7 +1605,8 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
 	if (IS_ERR(dp))
 		return;
 
-	WARN(dp->user_features, "Dropping previously announced user features\n");
+	pr_warn("%s: Dropping previously announced user features\n",
+		ovs_dp_name(dp));
 	dp->user_features = 0;
 }
 
-- 
2.35.1



