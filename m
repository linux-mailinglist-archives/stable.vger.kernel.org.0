Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48CF658416
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiL1QyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbiL1Qxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:53:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B111DF0C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:48:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E310B81889
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9BDC433F0;
        Wed, 28 Dec 2022 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246126;
        bh=AlYS/l6ElL7QqRBU9A8AzkmpdKoqNyTen6wL+yZBCuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g83vqsNs37a8E5lEO63v+OmVUIj7TVg+05nzPUWfwhIgj2kt5sKxbElsARq/1h2q7
         T6dMWubjxOY+dvlk0RQ96BVACB800o1dN8gOJfWbQ+XKbyZB2ENqpA2RQ074PV11Dd
         yBMNmQJ7GK2b1v/1vVR72KDE+QCv8Fas/oF0+dNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martin Liska <mliska@suse.cz>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0985/1146] qed (gcc13): use u16 for fid to be big enough
Date:   Wed, 28 Dec 2022 15:42:04 +0100
Message-Id: <20221228144357.119910404@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 7d84118229bf7f7290438c85caa8e49de52d50c1 ]

gcc 13 correctly reports overflow in qed_grc_dump_addr_range():
In file included from drivers/net/ethernet/qlogic/qed/qed.h:23,
                 from drivers/net/ethernet/qlogic/qed/qed_debug.c:10:
drivers/net/ethernet/qlogic/qed/qed_debug.c: In function 'qed_grc_dump_addr_range':
include/linux/qed/qed_if.h:1217:9: error: overflow in conversion from 'int' to 'u8' {aka 'unsigned char'} changes value from '(int)vf_id << 8 | 128' to '128' [-Werror=overflow]

We do:
  u8 fid;
  ...
  fid = vf_id << 8 | 128;

Since fid is 16bit (and the stored value above too), fid should be u16,
not u8. Fix that.

Cc: Martin Liska <mliska@suse.cz>
Cc: Ariel Elior <aelior@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20221031114354.10398-1-jirislaby@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 5250d1d1e49c..86ecb080b153 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -1972,9 +1972,10 @@ static u32 qed_grc_dump_addr_range(struct qed_hwfn *p_hwfn,
 				   u8 split_id)
 {
 	struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
-	u8 port_id = 0, pf_id = 0, vf_id = 0, fid = 0;
+	u8 port_id = 0, pf_id = 0, vf_id = 0;
 	bool read_using_dmae = false;
 	u32 thresh;
+	u16 fid;
 
 	if (!dump)
 		return len;
-- 
2.35.1



