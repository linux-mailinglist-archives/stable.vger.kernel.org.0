Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBBB4D8288
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240379AbiCNMFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240385AbiCNMFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:05:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDF9488BC;
        Mon, 14 Mar 2022 05:01:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4310B80DC2;
        Mon, 14 Mar 2022 12:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E49C340E9;
        Mon, 14 Mar 2022 12:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259303;
        bh=nHvW5rVPVOcGyFr0loHYgzmKepP2LxF/KCYMrToru7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wO3Kc55bcLqXyX2CqDN/3ms+PWWym7KYoLXh9q+wtxUC0pJVhSv4mZJoE5fcF68S3
         rwt9gf8RkTuYyw9J107y0SRqo4XXhA/JqrTpa/cx3z318Id391W1+XxSfBXSFqhD6R
         hpyg0Iwyh9kmIJLkRSRMwN9xnN3hNA6aILp9FemE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, suresh kumar <suresh2514@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/71] net-sysfs: add check for netdevice being present to speed_show
Date:   Mon, 14 Mar 2022 12:53:33 +0100
Message-Id: <20220314112739.054120064@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: suresh kumar <suresh2514@gmail.com>

[ Upstream commit 4224cfd7fb6523f7a9d1c8bb91bb5df1e38eb624 ]

When bringing down the netdevice or system shutdown, a panic can be
triggered while accessing the sysfs path because the device is already
removed.

    [  755.549084] mlx5_core 0000:12:00.1: Shutdown was called
    [  756.404455] mlx5_core 0000:12:00.0: Shutdown was called
    ...
    [  757.937260] BUG: unable to handle kernel NULL pointer dereference at           (null)
    [  758.031397] IP: [<ffffffff8ee11acb>] dma_pool_alloc+0x1ab/0x280

    crash> bt
    ...
    PID: 12649  TASK: ffff8924108f2100  CPU: 1   COMMAND: "amsd"
    ...
     #9 [ffff89240e1a38b0] page_fault at ffffffff8f38c778
        [exception RIP: dma_pool_alloc+0x1ab]
        RIP: ffffffff8ee11acb  RSP: ffff89240e1a3968  RFLAGS: 00010046
        RAX: 0000000000000246  RBX: ffff89243d874100  RCX: 0000000000001000
        RDX: 0000000000000000  RSI: 0000000000000246  RDI: ffff89243d874090
        RBP: ffff89240e1a39c0   R8: 000000000001f080   R9: ffff8905ffc03c00
        R10: ffffffffc04680d4  R11: ffffffff8edde9fd  R12: 00000000000080d0
        R13: ffff89243d874090  R14: ffff89243d874080  R15: 0000000000000000
        ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
    #10 [ffff89240e1a39c8] mlx5_alloc_cmd_msg at ffffffffc04680f3 [mlx5_core]
    #11 [ffff89240e1a3a18] cmd_exec at ffffffffc046ad62 [mlx5_core]
    #12 [ffff89240e1a3ab8] mlx5_cmd_exec at ffffffffc046b4fb [mlx5_core]
    #13 [ffff89240e1a3ae8] mlx5_core_access_reg at ffffffffc0475434 [mlx5_core]
    #14 [ffff89240e1a3b40] mlx5e_get_fec_caps at ffffffffc04a7348 [mlx5_core]
    #15 [ffff89240e1a3bb0] get_fec_supported_advertised at ffffffffc04992bf [mlx5_core]
    #16 [ffff89240e1a3c08] mlx5e_get_link_ksettings at ffffffffc049ab36 [mlx5_core]
    #17 [ffff89240e1a3ce8] __ethtool_get_link_ksettings at ffffffff8f25db46
    #18 [ffff89240e1a3d48] speed_show at ffffffff8f277208
    #19 [ffff89240e1a3dd8] dev_attr_show at ffffffff8f0b70e3
    #20 [ffff89240e1a3df8] sysfs_kf_seq_show at ffffffff8eedbedf
    #21 [ffff89240e1a3e18] kernfs_seq_show at ffffffff8eeda596
    #22 [ffff89240e1a3e28] seq_read at ffffffff8ee76d10
    #23 [ffff89240e1a3e98] kernfs_fop_read at ffffffff8eedaef5
    #24 [ffff89240e1a3ed8] vfs_read at ffffffff8ee4e3ff
    #25 [ffff89240e1a3f08] sys_read at ffffffff8ee4f27f
    #26 [ffff89240e1a3f50] system_call_fastpath at ffffffff8f395f92

    crash> net_device.state ffff89443b0c0000
      state = 0x5  (__LINK_STATE_START| __LINK_STATE_NOCARRIER)

To prevent this scenario, we also make sure that the netdevice is present.

Signed-off-by: suresh kumar <suresh2514@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 99303897b7bb..989b3f7ee85f 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -213,7 +213,7 @@ static ssize_t speed_show(struct device *dev,
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	if (netif_running(netdev)) {
+	if (netif_running(netdev) && netif_device_present(netdev)) {
 		struct ethtool_link_ksettings cmd;
 
 		if (!__ethtool_get_link_ksettings(netdev, &cmd))
-- 
2.34.1



