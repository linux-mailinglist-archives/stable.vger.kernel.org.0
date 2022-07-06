Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5CD56846F
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 11:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiGFJ5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 05:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbiGFJ5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 05:57:00 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AC925D9
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 02:56:58 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id m184so8533824wme.1
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 02:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oQmMEm8R63yDBFMVBDKxeDcvs7uNNmm4G/6GcZxeIkg=;
        b=xcHKPZCFLH+4W4z7z/H/8MzyO4wHmtY3vAz2gkL5sf6QCFGE9oJDTPO/YnSyjqDqu3
         hFZHoSxsOVrkUgYG1IEuzZ1nmebOOkeJwH1hTDcWBRoS2dLx9I0T7BH/AuI60qMMIJ5+
         hho9Mb97ejPk8C8lUl+bZi7mfCMWZwPQ3KvuMUvrbCJHIXDKloFc1OmFiIQ0LgRy7OXK
         EPEw+rMKAxmgZc57xFDdWNQaTUVwb0h9hudbnlF+gqVLNaDUATveSyEcpYUsWDtEhyKP
         VFcSUtb4xRBx2rW5wo+h+kkQopISxtJlX/rh3TpNBt+6k5vLet1wwoaU+TNO8LCRfcz1
         YtVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oQmMEm8R63yDBFMVBDKxeDcvs7uNNmm4G/6GcZxeIkg=;
        b=DBz+lMusRdew1nxSDIS4MxFTVGn3q4bqaWGxSjXQNxDBHMDCOSTrIXAfJeFIa2UB2l
         niC7XAT/E84FyTmqB4/WrmWJMV6NG0FRaPuk0c+XppmSl0tX7FlKgIBAzxj03MERZqMT
         CRcbRIE603H3BVGyQhJUqF5E2j6ts+yod+zr1UX3wQ3PYohoaG04+2GTVjsc7SOkVDgd
         KGxapDkPmdFTt+fnUvkKMpdtwobi5EQ4Gn/0xBgbxt9u7zoM3UDs6Vichn4Koip4ibqK
         UqxS2cmfwVpu+2nMZCRhM/J7tMMzyZvZXlDqy5TGnnbrGTyQuXCaFsO5d/Qmt+srnTZX
         gOjQ==
X-Gm-Message-State: AJIora/n+iKlpdnGJDTyjtm04VMnaexU21PQHJLNAt+/lLqGmN6MlJOk
        Rb+yv6Dr9vouGrzqHtXCpVmLag==
X-Google-Smtp-Source: AGRyM1uU55Ngph1vNp6yKEA3e3ftMEDUT75j78jU8Ow98uLQ55SnXHsTE3ElD47QQ82ShMCXfG10NQ==
X-Received: by 2002:a05:600c:4f48:b0:3a0:45dd:8bd5 with SMTP id m8-20020a05600c4f4800b003a045dd8bd5mr43952822wmq.80.1657101417104;
        Wed, 06 Jul 2022 02:56:57 -0700 (PDT)
Received: from srini-hackbase.lan (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.gmail.com with ESMTPSA id u1-20020a5d6ac1000000b0021b95bcaf7fsm7723390wrw.59.2022.07.06.02.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 02:56:56 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     vkoul@kernel.org
Cc:     yung-chuan.liao@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, alsa-devel@alsa-project.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] soundwire: qcom: Check device status before reading devid
Date:   Wed,  6 Jul 2022 10:56:44 +0100
Message-Id: <20220706095644.5852-1-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As per hardware datasheet its recommended that we check the device
status before reading devid assigned by auto-enumeration.

Without this patch we see SoundWire devices with invalid enumeration
addresses on the bus.

Cc: stable@vger.kernel.org
Fixes: a6e6581942ca ("soundwire: qcom: add auto enumeration support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/soundwire/qcom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index dbf793e7e5d7..9df970eeca45 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -480,6 +480,10 @@ static int qcom_swrm_enumerate(struct sdw_bus *bus)
 	char *buf1 = (char *)&val1, *buf2 = (char *)&val2;
 
 	for (i = 1; i <= SDW_MAX_DEVICES; i++) {
+		/* do not continue if the status is Not Present  */
+		if (!ctrl->status[i])
+			continue;
+
 		/*SCP_Devid5 - Devid 4*/
 		ctrl->reg_read(ctrl, SWRM_ENUMERATOR_SLAVE_DEV_ID_1(i), &val1);
 
-- 
2.25.1

