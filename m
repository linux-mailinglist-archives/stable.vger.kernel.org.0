Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488B158C649
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 12:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbiHHKWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 06:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242578AbiHHKW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 06:22:26 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094C013F12
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 03:22:24 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id j8so15690815ejx.9
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 03:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ulIy3G2EbIgqsnovjTBrH0rdmHx+pgjTUXc5u47Dtro=;
        b=DVpn95L8cUMujDikof/RVQ2Ok3oCbfsyDQCUvPwqvfzTFDe1/4FifFvdL/gYcpKzc3
         AHO2u6k8z8n8sp/uIQkglPN+FaqUJymCJ9QwPJL967CLWmA7rAaSvu6M0E0s4mh5xLWw
         p3CgPY94o1Mb+KA8JZKlmS9zquG8cT3/xMBX/8NKFq7uBriTJaSGaAbOvozf8jdDVqRC
         r/t8mN2lLj9AcxHseUg6EeQ1Gsy4if0MeHmxRWGSnR0CtXuyJjAvh1QeUB+lbdY+FJkc
         6F2LeHTdvHKb8aG/55/T7SOLuPeA8/ol7pvUxOZBevJnQHmAj9Wj+X47XRrp+k1v5Gl/
         uijA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ulIy3G2EbIgqsnovjTBrH0rdmHx+pgjTUXc5u47Dtro=;
        b=DFDPeNlAdWQrQ0hVPtIRb/tz1tsLwxHiKwU1BcUSGp3O+DlMv1Z2SrcN2Q+osJDWZw
         CwedPvH9M7Z4mWrBtgcqaOOHh9OUJJWjqoBBgC+vGEIALk3rhy31XmEKnQbS1LpNdkQ3
         l1LPAAMi3MoaUB0r2VkJrJTw9dr39rQ4rN/v57Ij/7gx2s8mIk2tHBZ9L83yYi6jV+WP
         bOA1iOT/S0EkMzDrmbkXvqoClDhXd1nIrFHKEuLowJTUHkJYFfpv4+A9kZOrcl64pijc
         dqmkBg58TEWMyb5tGBSTcIidImWkuHsIB+Rw8f39LTMzaoyBj7Y+szRLH+br0TC7fwNr
         1W2A==
X-Gm-Message-State: ACgBeo2shw1f5lrgwwbmbUZAoK2bNfPgNwUEdexWWdH1h27krilRc8ND
        fV9feuO5aF9sXT7QasYqwjH+FThQK5A=
X-Google-Smtp-Source: AA6agR53rjMuHIr4uY1v9B1DyXcY18qZkeYyilKobPsykyDaLrbIwLje9QUnhIGaObk0dhNGlxKS2g==
X-Received: by 2002:a17:906:6a0f:b0:730:df34:6ec4 with SMTP id qw15-20020a1709066a0f00b00730df346ec4mr12299132ejc.659.1659954143470;
        Mon, 08 Aug 2022 03:22:23 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af044400b9d54df6b07d4ee8.dip0.t-ipconnect.de. [2003:f6:af04:4400:b9d5:4df6:b07d:4ee8])
        by smtp.googlemail.com with ESMTPSA id c10-20020a17090618aa00b00730af3346d6sm4822994ejf.212.2022.08.08.03.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 03:22:22 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 0/1] selinux: allow dontauditx and auditallowx rules to take effect without allowx
Date:   Mon,  8 Aug 2022 12:20:48 +0200
Message-Id: <20220808102049.46386-1-theflamefire89@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes an inconsistency, if not a clear bug, with the extended permissions.
To quote from the original discussion [1]:
> The behavior of dontauditx and auditallowx appears to be broken making them useless.

[1] https://lore.kernel.org/selinux/6a791504-7728-3026-17ee-c22cbff8c3d1@gmail.com/T/

bauen1 (1):
  selinux: allow dontauditx and auditallowx rules to take effect without allowx

 security/selinux/ss/services.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

-- 
2.25.1

