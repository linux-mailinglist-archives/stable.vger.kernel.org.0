Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33785B48FD
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiIJVQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiIJVQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:16:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224CD47B88;
        Sat, 10 Sep 2022 14:16:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A030960DD4;
        Sat, 10 Sep 2022 21:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4C4C433C1;
        Sat, 10 Sep 2022 21:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844590;
        bh=fisER/uHOHzxDeiiE0kTtSX09vFJQsYiGGMe5WNMp9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+BgYHf9JLhfWcZxi/6MgfiBQXtdH6Gscupc/OEQXMl5fwbAO3Gxo/n33cqh1Dme/
         zbQPS0hMRcGh18gs+TkozD7W/CCi9U+TtKGyNlm+9W5/8Ns2KevxAzoOAg0lrGHL2Y
         7ZpVQ456oLXwu7lTYA/5To+ICGSpjtM5HTa6J1EoYdoaBRmNW96d8rN/yZDanqROlM
         LW06vwsIvWpmPnZu5Dql3cJinBho1uG10mbiYhHgE2WwvNFUn7hUmB0X3UhTGmtKiI
         O8lMg5ngGMlCSKKPQE0SNqT7ONZa/IHMSUJEXlWo7J6CNYM/yGrDg5GS3Nm+PXzFoH
         HFTC0+CT8pBeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Iwona Winiarska <iwona.winiarska@intel.com>,
        Jianglei Nie <niejianglei2021@163.com>,
        Sasha Levin <sashal@kernel.org>, openbmc@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.19 04/38] peci: cpu: Fix use-after-free in adev_release()
Date:   Sat, 10 Sep 2022 17:15:49 -0400
Message-Id: <20220910211623.69825-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Iwona Winiarska <iwona.winiarska@intel.com>

[ Upstream commit 1c11289b34ab67ed080bbe0f1855c4938362d9cf ]

When auxiliary_device_add() returns an error, auxiliary_device_uninit()
is called, which causes refcount for device to be decremented and
.release callback will be triggered.

Because adev_release() re-calls auxiliary_device_uninit(), it will cause
use-after-free:
[ 1269.455172] WARNING: CPU: 0 PID: 14267 at lib/refcount.c:28 refcount_warn_saturate+0x110/0x15
[ 1269.464007] refcount_t: underflow; use-after-free.

Reported-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Iwona Winiarska <iwona.winiarska@intel.com>
Link: https://lore.kernel.org/r/20220705101501.298395-1-iwona.winiarska@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/peci/cpu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/peci/cpu.c b/drivers/peci/cpu.c
index 68eb61c65d345..de4a7b3e5966e 100644
--- a/drivers/peci/cpu.c
+++ b/drivers/peci/cpu.c
@@ -188,8 +188,6 @@ static void adev_release(struct device *dev)
 {
 	struct auxiliary_device *adev = to_auxiliary_dev(dev);
 
-	auxiliary_device_uninit(adev);
-
 	kfree(adev->name);
 	kfree(adev);
 }
@@ -234,6 +232,7 @@ static void unregister_adev(void *_adev)
 	struct auxiliary_device *adev = _adev;
 
 	auxiliary_device_delete(adev);
+	auxiliary_device_uninit(adev);
 }
 
 static int devm_adev_add(struct device *dev, int idx)
-- 
2.35.1

