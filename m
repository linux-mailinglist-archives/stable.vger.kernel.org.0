Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7472E594D06
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350932AbiHPAaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351080AbiHPA3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:29:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC7C181C4F;
        Mon, 15 Aug 2022 13:35:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEC326120E;
        Mon, 15 Aug 2022 20:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B26C433D6;
        Mon, 15 Aug 2022 20:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595707;
        bh=Ih/6iQhAoZQZ9u2ZnYtMRwIxGHBSliM25XgUUlJTEXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mF4sCLxS2vrBmRxZn1AQ1jhBIaJ3tz/bpmZmJ6FG9lZCiIwHGpYHmUQIOQCUCUw8F
         QQ1bvr0ZgjXz15702Ic0Y+RqvhBYwsjCzsyxnDGAZZRpnfsOgY387/OYjYhamepAS1
         ntT6RytcoYbUpz/frcwSBp+epTN0HLDx3K38ZbgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0849/1157] HID: amd_sfh: Handle condition of "no sensors"
Date:   Mon, 15 Aug 2022 20:03:25 +0200
Message-Id: <20220815180513.456703773@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 5d4d0f15657535f6a122ab26d47230b5c2b944af ]

Add a check for num_hid_devices to handle special case the situation
of "no sensors".

Fixes: 4b2c53d93a4b ("SFH:Transport Driver to add support of AMD Sensor Fusion Hub (SFH)")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index 0f770a2b47ff..e27ee1871066 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -173,6 +173,8 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 	dev = &privdata->pdev->dev;
 
 	cl_data->num_hid_devices = amd_mp2_get_sensor_num(privdata, &cl_data->sensor_idx[0]);
+	if (cl_data->num_hid_devices == 0)
+		return -ENODEV;
 
 	INIT_DELAYED_WORK(&cl_data->work, amd_sfh_work);
 	INIT_DELAYED_WORK(&cl_data->work_buffer, amd_sfh_work_buffer);
-- 
2.35.1



