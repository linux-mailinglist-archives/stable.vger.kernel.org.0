Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1925BAAB1
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiIPKWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiIPKVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:21:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F010299B59;
        Fri, 16 Sep 2022 03:13:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86B2FB82539;
        Fri, 16 Sep 2022 10:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC476C433C1;
        Fri, 16 Sep 2022 10:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323206;
        bh=fisER/uHOHzxDeiiE0kTtSX09vFJQsYiGGMe5WNMp9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TO0nvTXYToMIj0M7kXWTrdqS/mzLMrN33o4woE3WV1JxzJfsrcoZARqp94GSTzdvV
         1ygTAaPohv7V3P7ScvtDiw7Zr7tl10OS8w80o9qjj6Kdv1/2lmBP6Q9/pZMkVQ7fBj
         YQ+fY2J6GuiYr9XGMpwCsMm2v2mkaG6hvLWvF57Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Iwona Winiarska <iwona.winiarska@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 11/38] peci: cpu: Fix use-after-free in adev_release()
Date:   Fri, 16 Sep 2022 12:08:45 +0200
Message-Id: <20220916100448.943435526@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
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



