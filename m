Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973EF58C80E
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 14:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242951AbiHHMBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 08:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242776AbiHHMA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 08:00:57 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F27D1C2
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 05:00:56 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id kb8so16171291ejc.4
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 05:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=EGkN+sINJe/3aEWfVGWBGrQBTuSuhce5c++LYrm3Hu8=;
        b=gfPZQQ7k/wlCLZAN712K76dMxDKWMLsI+mSD1lgMLWohfLJbqB5izgI9KyhZ4OnK+P
         852A+wuvUIm3kPLyBS9HcNJn9lrqLSgBxaWBTG8Hm07Z63D2yEC9R9zGltkxUm2FiDcB
         rF5KFldI+RNXddmkjWbznfFB69oKAGbcJzzs6/u8J+v0HMe94sbZNQh4KneXu5FWYUYd
         qzH8IINEdAGn5pZDyjsPuL/U5FKoWap241azc/dtMIP+TAF56J2ISvVNyHDcNe4LLUaw
         5JQsAJfy1zueZxJSuSF5QfB7SL3PtZTo8CxT5JO8xIQYGA7un2LHGj/wFCGKPpQ00Cz4
         fBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=EGkN+sINJe/3aEWfVGWBGrQBTuSuhce5c++LYrm3Hu8=;
        b=U/HOFKF+v4U5sqtfxV7iODp5B1U60qIG9Z6PjLBqjV7wTKCzoCXCS1FVRSXBAc3oUQ
         H/aObgTOiWQcFkeA/IajR5EUH7IIaEZJfuGZNJ8BY7y9xdJj2Z5BRzPTPht09875+X0a
         DBPmhwHIetrcEpcg953ryPmL2e0ChK2mfmtTEPibmGY2O4apZw335CrdnHVMAHBk5fFl
         5UXVpeYBDKrlCjZkGju7/iIqft5vP2i/ye8Re3hz25gk41nglCRjS3oTwviDoZSzPGXd
         fGC2HLTgJ1NI2xbBjT+lTZbhIaAasrsB9GMyA+uwQCE57PHBPAZ3SCmhR0cTvbvGBp2b
         RuzA==
X-Gm-Message-State: ACgBeo3UaUc+AKEYuxc0XhK1n0GYRi+AuUbk0OHTdW1/42j0OX51O/TN
        OsutxtWRmykRkCnXXlU+5BIsT0cBiZ4=
X-Google-Smtp-Source: AA6agR6PphMwJwbsYwJ1+9YBFc0/pdS1em73efb1iBT+JjGv9Msa1BGjhNOlXowBpsVWdyDxyloEyQ==
X-Received: by 2002:a17:906:fe46:b0:730:ca2b:cb7b with SMTP id wz6-20020a170906fe4600b00730ca2bcb7bmr14122205ejb.703.1659960054849;
        Mon, 08 Aug 2022 05:00:54 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af044400b9d54df6b07d4ee8.dip0.t-ipconnect.de. [2003:f6:af04:4400:b9d5:4df6:b07d:4ee8])
        by smtp.googlemail.com with ESMTPSA id r13-20020a17090638cd00b007304924d07asm4962544ejd.172.2022.08.08.05.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 05:00:54 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 0/1] selinux: drop super_block backpointer from superblock_security_struct
Date:   Mon,  8 Aug 2022 13:59:21 +0200
Message-Id: <20220808115922.331003-1-theflamefire89@gmail.com>
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

This backports a commit from upstream which I would consider a cleanup
as well as a (minor) performance fix due to less memory being used and
avoiding an unneccessary pointer dereferencing, i.e. the change
from `sbsec->sb->s_root` to `sb->s_root`.

However as it changes the `superblock_security_struct` please check if
this violates any API/ABI stability requirements which I'm not aware of.

Ondrej Mosnacek (1):
  selinux: drop super_block backpointer from superblock_security_struct

 security/selinux/hooks.c          | 5 ++---
 security/selinux/include/objsec.h | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

-- 
2.25.1

