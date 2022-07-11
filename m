Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C59A56FF74
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiGKKuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiGKKuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:50:17 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACF7F5D7A
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 02:56:35 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id oy13so3052467ejb.1
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 02:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AzHSm3zRODxzxvxDJzNyfaExH+jb1kAqzLj2G32+s9E=;
        b=ZFnWZB9D69L26m9L3EHuoFD/zwn2T0aF+0s9nO5/2tdmixYnRJfJRrx6CVeYza+661
         nXX8BwYDyQxMaO+u7FuLrHOshm27QPSy2f/crIWdSJK3gL9Pwl2KUTLnJrLvgPlfZobt
         08qCaaF5FCMHyMcGUn4ve7ClzpIk57kfKcZ6oY4hsD+r4r69/MDlPrvkR5HRI+Fnfeyj
         afSTfFmxuo1f1IqLKR+sTyMjZCfS9HTw3wruJ2HCJbzgmLmTfSSqEAsxs5RlLtyLJk0c
         CLNGzBdPH7y0KUiKl03BzrKCV5zJEd8tYwGTLp3bgfIh8iRg2PCcV49txk/657DuIOjZ
         v6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AzHSm3zRODxzxvxDJzNyfaExH+jb1kAqzLj2G32+s9E=;
        b=7nrtG5OIzfXSRZWs0YWqshhO40RjOW55pUZ9dx+hIEyqbifKt7s5CZGmXIahpeest3
         A6nvwWE6ed2PYqbbYrFuAS4tqjD7oC23qoXhV8s0HHcLDsWhFVg6KgAvryVvW9XrWwy6
         g5Af251yGzMvOygeXM5+Debnj3amje8pWMnHxANykaMlBh/OeCJ0DYu2x10gPKtnrmpR
         r+5qRvu2OSYSeurPi6m4wCyRiqLwXe7IGBjN5Y8djFiTdJrSlJT1Gj6dfyotzG85m5BX
         uaD2AuPUj0VJ6argldy+bW7KqT70Z+o8D39l7yOV6zVQmUy6HZdwSnlcpxqGzfDpeo1/
         3a5g==
X-Gm-Message-State: AJIora+lPDi/IGU9sAKHpJ8l965VjAbtX+X/ZSo4AjnaYTYLCBPgvzVS
        659LBpm5c6SOMf/zQ9hgmIihv9lpuQmaRw==
X-Google-Smtp-Source: AGRyM1t3rMvs/sJKU2nI33XrN3uF6ubF+okLG9x0TIMJTYdIJDOWZWarSMrKfvbur472w9qE33/XyQ==
X-Received: by 2002:a17:907:6d1d:b0:72b:6d8a:ca64 with SMTP id sa29-20020a1709076d1d00b0072b6d8aca64mr289407ejc.371.1657533394039;
        Mon, 11 Jul 2022 02:56:34 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af09360009b69b4e98d64e49.dip0.t-ipconnect.de. [2003:f6:af09:3600:9b6:9b4e:98d6:4e49])
        by smtp.googlemail.com with ESMTPSA id vs24-20020a170907139800b00703671ebe65sm2480557ejb.198.2022.07.11.02.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 02:56:32 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 0/1] security,selinux,smack: kill security_task_wait hook
Date:   Mon, 11 Jul 2022 11:56:07 +0200
Message-Id: <20220711095608.4723-1-theflamefire89@gmail.com>
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

The following (backported) patch removes a hook which has already been removed upstream. [1]
Reason is that a permission denial can lead to soft lockups and zombies.
A reproducer can be found in the initial report. [2]
I hence consider this a bugfix which is allowed for stable branches.

Background:
To reduce divergence of 4.9 to upstream before proposing to apply upstream commit
3dfc9b02864bt (LSM: Initialize security_hook_heads upon registration.)
I'm checking which changes to the LSM hooks may be applicable to 4.9 as
doing so after backporting 33dfc9b02864bt will lead to conflicts for each such commit.

[1] https://patchwork.kernel.org/project/linux-security-module/patch/1484069312-26653-1-git-send-email-sds@tycho.nsa.gov/
[2] https://patchwork.kernel.org/project/selinux/patch/58736B2E.90201@huawei.com

Stephen Smalley (1):
  security,selinux,smack: kill security_task_wait hook

 include/linux/lsm_hooks.h  |  7 -------
 include/linux/security.h   |  6 ------
 kernel/exit.c              | 19 ++-----------------
 security/security.c        |  6 ------
 security/selinux/hooks.c   |  6 ------
 security/smack/smack_lsm.c | 20 --------------------
 6 files changed, 2 insertions(+), 62 deletions(-)

-- 
2.25.1

