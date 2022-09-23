Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCE85E8069
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 19:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiIWRKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 13:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbiIWRKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 13:10:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5B41162DB;
        Fri, 23 Sep 2022 10:10:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9C334219EC;
        Fri, 23 Sep 2022 17:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663953043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ZSPBzEUu4HvvRKKrmrdU/FMS6Qx20fLyxT3yF1tghgc=;
        b=uumJiLIU2hCeUjB//pYmunQ3XhUTmH5n97IVRpx0df4OZYv5fuXBQ0xekIy4XJccvKNdf+
        ZZ2q/2pniI8zXucmq84IOe9+SqdEoZRhNamUxbx08sYZ/Rz9mhwPlaqhD1IuXjRA5vy2v5
        Iqu37b4i4NZhqLy45/3MLfqEcVgd2Os=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663953043;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ZSPBzEUu4HvvRKKrmrdU/FMS6Qx20fLyxT3yF1tghgc=;
        b=Fngpn3ub5IEe7UJDgzoo8OBgYwiwTJAr8CYGfJ5/Ppmar1cb8XYsiESPKo8Bi3lpB3A8SE
        scN82gpoaRkfC7CQ==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        by relay2.suse.de (Postfix) with ESMTP id 44B9C2C15B;
        Fri, 23 Sep 2022 17:10:41 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Philipp Rudo <prudo@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Baoquan He <bhe@redhat.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        linux-s390@vger.kernel.org (open list:S390),
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT
        (AARCH64 ARCHITECTURE)),
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC (32-BIT AND
        64-BIT)), kexec@lists.infradead.org (open list:KEXEC),
        Coiby Xu <coxu@redhat.com>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH 5.15 0/6] arm64: kexec_file: use more system keyrings to verify kernel image signature + dependencies
Date:   Fri, 23 Sep 2022 19:10:28 +0200
Message-Id: <cover.1663951201.git.msuchanek@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

this is backport of commit 0d519cadf751
("arm64: kexec_file: use more system keyrings to verify kernel image signature")
to table 5.15 tree including the preparatory patches.

Some patches needed minor adjustment for context.

Thanks

Michal


Coiby Xu (3):
  kexec: clean up arch_kexec_kernel_verify_sig
  kexec, KEYS: make the code in bzImage64_verify_sig generic
  arm64: kexec_file: use more system keyrings to verify kernel image
    signature

Naveen N. Rao (2):
  kexec_file: drop weak attribute from functions
  kexec: drop weak attribute from functions

Sven Schnelle (1):
  s390/kexec_file: move kernel image size check

 arch/arm64/include/asm/kexec.h        | 20 ++++++-
 arch/arm64/kernel/kexec_image.c       | 11 +---
 arch/powerpc/include/asm/kexec.h      | 14 +++++
 arch/s390/boot/head.S                 |  2 -
 arch/s390/include/asm/kexec.h         | 14 +++++
 arch/s390/include/asm/setup.h         |  1 -
 arch/s390/kernel/machine_kexec_file.c | 17 +-----
 arch/x86/include/asm/kexec.h          | 12 ++++
 arch/x86/kernel/kexec-bzimage64.c     | 20 +------
 include/linux/kexec.h                 | 82 ++++++++++++++++++++++----
 kernel/kexec_core.c                   | 27 ---------
 kernel/kexec_file.c                   | 83 ++++++++++-----------------
 12 files changed, 163 insertions(+), 140 deletions(-)

-- 
2.35.3

