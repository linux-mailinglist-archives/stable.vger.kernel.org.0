Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470B968D836
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjBGNHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjBGNHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A29830B31
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:07:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0C0FB8199F
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BB9C4339B;
        Tue,  7 Feb 2023 13:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775222;
        bh=sW2sqmw7CZZM1sIiWHvBXxQBmrWLvLJjyCvk8m7LSR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RIkwP7JL61K6THu2UAogkcS5vMS15erlB47FQJA+QcptOms9dIO/lZhB7i4+s4JA
         JbkLjbZJf2vrup1z68cYuJgcPHSix+cKOBH7SeDu7q84azsHjB4o1griyuFY7KbHz2
         HVUt7IV4aNOSIvefB2N4ttjjyfH7w/8pmkkIOLCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 148/208] nvmem: brcm_nvram: Add check for kzalloc
Date:   Tue,  7 Feb 2023 13:56:42 +0100
Message-Id: <20230207125641.137790659@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit b0576ade3aaf24b376ea1a4406ae138e2a22b0c0 upstream.

Add the check for the return value of kzalloc in order to avoid
NULL pointer dereference.

Fixes: 6e977eaa8280 ("nvmem: brcm_nvram: parse NVRAM content into NVMEM cells")
Cc: stable@vger.kernel.org
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/brcm_nvram.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nvmem/brcm_nvram.c
+++ b/drivers/nvmem/brcm_nvram.c
@@ -97,6 +97,9 @@ static int brcm_nvram_parse(struct brcm_
 	len = le32_to_cpu(header.len);
 
 	data = kzalloc(len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	memcpy_fromio(data, priv->base, len);
 	data[len - 1] = '\0';
 


