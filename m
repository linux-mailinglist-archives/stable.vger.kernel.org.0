Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE28501818
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 18:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350236AbiDNQBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 12:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354496AbiDNPlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 11:41:04 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64872DF4A7
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 08:21:38 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id o127so431947iof.12
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 08:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mfrhGGBj0Sk85zrOhsdb8TtI3LhLRBO2IGMEqKkv48Y=;
        b=S34Elk1ApvpkJYWjF40GIat8OsWthtJZVaaQGOfyyMsoRkpWWfPhz+BGcDu0yXKbJm
         tQBqFQ+v+Zu1Zy5uiYcG5ru9LNtmq2c0A1x64SKmy1iVcf+wkSi3v2wEHePjckeuvoBz
         vtxoSHAPBu6l/NBpL4zCXIc9DeA/2zERopU5u1PpbB2iSgsTuZW6kGSdYpaCmTqlUC/0
         Uf5i4/mXresmUMDdUgmMc0wGQUsjNCqeTy3/Z8bV4D30vD7+qz9hukLnb3GA6glPn5yZ
         Eox4WzPThJZ0zOvHYH/BESKx6Y22gzL4p0xUNzEHQB66G990Eo+ENmYiDwEJ1X+1Dd/c
         KTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mfrhGGBj0Sk85zrOhsdb8TtI3LhLRBO2IGMEqKkv48Y=;
        b=fSKs3aclwnhOojuX6nESjvHV89P+A+AesVwkZCV+JkOT6pWMSX82eycOJHR7AfnWBG
         zAnemSicW7uKgjpZ4Q3nLcbVxqjsMy+MjY/KIYkbkCFIYq9BZpm5QbvycOScb5qLZcbK
         XkKDd+TzGu5Xjftg9Vx5DnkRyE+2N87KtERI+asOuo1pGGx+pGa6bZ51LLvXXdAcn0+L
         6qceSIa66LIaNU+Cdmu0Xrxd7S5TOCyF084JBhX106UNoUDjt6WWRatL6RzHAVPU1p6D
         3U2qqRPU+NIZpjTlB+u8SvH3iHuqOWtf5sEm44crxSmGIY/rwFG0z2iBwK+ucVDtIKhD
         vhww==
X-Gm-Message-State: AOAM532ATeqwmujteLvqsrqqA/UGYN48aym8cV24iDIYlm5qOnqtZYuy
        KJCke0nDKGhdwFkfYivPdGvJFm2gyFhsIw==
X-Google-Smtp-Source: ABdhPJy33AvCrKBtk/iHu+c2VcZfpcqk2g1NKM3zYoTSgu0WRa1bNyPfjLX0zL2sd1UFFSW7boouiQ==
X-Received: by 2002:a05:6602:1648:b0:647:9f39:1272 with SMTP id y8-20020a056602164800b006479f391272mr1296453iow.146.1649949697494;
        Thu, 14 Apr 2022 08:21:37 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2-20020a056602160200b006463c1977f9sm1365395iow.22.2022.04.14.08.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 08:21:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     stable@vger.kernel.org
Cc:     kuba@kernel.org, bjorn.andersson@linaro.org, quic_clew@quicinc.com,
        quic_deesin@quicinc.com, swboyd@chromium.org, elder@kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH v2 2/3] dt-bindings: net: qcom,ipa: add optional qcom,qmp property
Date:   Thu, 14 Apr 2022 10:21:30 -0500
Message-Id: <20220414152131.713724-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220414152131.713724-1-elder@linaro.org>
References: <20220414152131.713724-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ac62a0174d62ae0f4447c0c8cf35a8e5d793df56 upstream.

For some systems, the IPA driver must make a request to ensure that
its registers are retained across power collapse of the IPA hardware.
On such systems, we'll use the existence of the "qcom,qmp" property
as a signal that this request is required.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/devicetree/bindings/net/qcom,ipa.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index b8a0b392b24ea..c52ec1ee7df6e 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -106,6 +106,10 @@ properties:
           - const: imem
           - const: config
 
+  qcom,qmp:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: phandle to the AOSS side-channel message RAM
+
   qcom,smem-states:
     $ref: /schemas/types.yaml#/definitions/phandle-array
     description: State bits used in by the AP to signal the modem.
@@ -221,6 +225,8 @@ examples:
                                      "imem",
                                      "config";
 
+                qcom,qmp = <&aoss_qmp>;
+
                 qcom,smem-states = <&ipa_smp2p_out 0>,
                                    <&ipa_smp2p_out 1>;
                 qcom,smem-state-names = "ipa-clock-enabled-valid",
-- 
2.32.0

