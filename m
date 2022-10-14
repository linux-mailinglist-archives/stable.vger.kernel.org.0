Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827145FF2C7
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 19:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiJNRLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 13:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiJNRLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 13:11:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF41D1D5E01
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 10:10:54 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m3-20020a170902bb8300b0017f7e7e4385so3646884pls.20
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 10:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v9ap2GLZvM/h5WRSh6U8yqJEQTu6U3qmUyyLz0cSVPc=;
        b=EHXIjcEVaP7GqJu7+/7iwMQnBTtvMzb0JNHXjKS/ZxLiViC57AmLU08ZKnjpnGCP3S
         YgBZrJcXF0nYt6Oj8HeoePeKbFrCOcPGOd2U0bXoD9U57xmAD1ElzzgboS9ngHKQ6sm3
         73I+Qo3dmVEV/XMEkXmIZrGDSCYB+hcsKmHvu+LxfAlrWEe9PzzhujoJVskKUavQDINh
         lpLlENpfUFYBCNdnKtl8qLYecLygj0ue1C/qrZvwaKcPjndqm0v+0ulPPgte2XmrpXF6
         wfyrFIazoOr/rsFFudAktPdpwATeRmQhaqS6rqXaSYU8F4vAiamH6zZzcxbAPFwaksk5
         t9Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v9ap2GLZvM/h5WRSh6U8yqJEQTu6U3qmUyyLz0cSVPc=;
        b=RwbVjz4M6O8Eih5IrwzeFx2JqmkNYpMZh1HJmfow+GvL6iNkcOlhBw9ZqaDSPKqnAi
         Qd3Sn5Hy2mytgnGUKET/822h/lXFKoVC6Es8MHiD9KVRkNzdD3fad+8SOxCCSVoZYBDy
         CFPxsVZzB9XGPAr+nLkg9DXrayuw6Tau8k6AY+Rf/jAz1WEw6nuySBSPigBCKYtc1ST5
         mw4Q/N+kktQPvYBWJeKySUyBzFn+oa406HDMAx2Lueh//dl/4g9d7OpPa2tRL4i1DUCA
         9x/+H+dvVfC+ubT4p07G09i1ZwLhreyZ+PdchZ+3FMa7xe/Yem+37OAEKW9b8ikyLvZL
         +pug==
X-Gm-Message-State: ACrzQf3+nOXDu8aCYhbnKOn7XTPB7D+4c53sGF3Moll+js2MalMSzJlq
        qUSNTV/MdtDDYRxzQuGjEVcTCHnfyMNv0yFxD/M=
X-Google-Smtp-Source: AMsMyM4YzRBXmzyhCa/4pBcn2mG0C8gX42INaXx++KNjjHjH35AjvdUI0Z61ht5TLtZm4/EMlCQbZM29Psqw2nv0hHA=
X-Received: from ndesaulniers-desktop.svl.corp.google.com ([2620:0:100e:712:ff3e:881c:4c2c:b8c9])
 (user=ndesaulniers job=sendgmr) by 2002:a62:1744:0:b0:562:4e9b:3e0c with SMTP
 id 65-20020a621744000000b005624e9b3e0cmr6202729pfx.63.1665767452872; Fri, 14
 Oct 2022 10:10:52 -0700 (PDT)
Date:   Fri, 14 Oct 2022 10:10:40 -0700
In-Reply-To: <Y0mSVQCQer7fEKgu@kroah.com>
Mime-Version: 1.0
References: <Y0mSVQCQer7fEKgu@kroah.com>
X-Developer-Key: i=ndesaulniers@google.com; a=ed25519; pk=UIrHvErwpgNbhCkRZAYSX0CFd/XFEwqX3D0xqtqjNug=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1665767440; l=2239;
 i=ndesaulniers@google.com; s=20220923; h=from:subject; bh=kVkxjDQc5kjwHf3srGXAwtiAks3feBD+FzGTuZwcG7s=;
 b=xBNfNpF27rA58YIkIpHdFJ8sCZIZsRqpxhp19dqNIfQZGlYiV1zD8vSBeuNSlVsyMVwkwB4BqEkh
 8b6o41b2BqirH9MpbAfxx9PHV7mtZTw0Rn5RAqE/2zrNXGHNS2Rt
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221014171040.849726-1-ndesaulniers@google.com>
Subject: [PATCH v2] Documentation: process: replace outdated LTS table w/ link
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tyler Hicks <code@tyhicks.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The existing table was a bit outdated.

3.16 was EOL in 2020.
4.4 was EOL in 2022.

5.10 is new in 2020.
5.15 is new in 2021.

We'll see if 6.1 becomes LTS in 2022.

Rather than keep this table updated, it does duplicate information from
multiple kernel.org pages. Make one less duplication site that needs to
be updated and simply refer to the kernel.org page on releases.

Suggested-by: Tyler Hicks <code@tyhicks.com>
Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Changes v1 -> v2:
* Rather than update table, use a link as per Tyler and Bagas.
* Carry forward GKH's SB tag.

 Documentation/process/2.Process.rst | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/Documentation/process/2.Process.rst b/Documentation/process/2.Process.rst
index e05fb1b8f8b6..6a919cffcbfd 100644
--- a/Documentation/process/2.Process.rst
+++ b/Documentation/process/2.Process.rst
@@ -126,17 +126,10 @@ than one development cycle past their initial release. So, for example, the
 5.2.21 was the final stable update of the 5.2 release.
 
 Some kernels are designated "long term" kernels; they will receive support
-for a longer period.  As of this writing, the current long term kernels
-and their maintainers are:
-
-	======  ================================	=======================
-	3.16	Ben Hutchings				(very long-term kernel)
-	4.4	Greg Kroah-Hartman & Sasha Levin	(very long-term kernel)
-	4.9	Greg Kroah-Hartman & Sasha Levin
-	4.14	Greg Kroah-Hartman & Sasha Levin
-	4.19	Greg Kroah-Hartman & Sasha Levin
-	5.4	Greg Kroah-Hartman & Sasha Levin
-	======  ================================	=======================
+for a longer period.  Please refer to the following link for the list of active
+long term kernel versions and their maintainers:
+
+	https://www.kernel.org/category/releases.html
 
 The selection of a kernel for long-term support is purely a matter of a
 maintainer having the need and the time to maintain that release.  There

base-commit: 9c9155a3509a2ebdb06d77c7a621e9685c802eac
-- 
2.38.0.413.g74048e4d9e-goog

