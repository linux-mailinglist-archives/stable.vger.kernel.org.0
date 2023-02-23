Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90506A07C3
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 12:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjBWLx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 06:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbjBWLx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 06:53:57 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3851C320
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 03:53:55 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536cad819c7so109237027b3.6
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 03:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BkDvAde+xEB9EcrHYCd3LbwuRS92d6Mc0FVT1jwspM8=;
        b=Z35YhhszAtXdYFobCxj/aziJglcANrpaMxpi1CDSCv7IjJzEM4Wivn62WJCVNrek6a
         Cz/mx3z5CtSkgVeo/xIa9uUe/H+99BPkqJ+RWF3jYjBNpH1V5JNyz/LM31i2g0fk7WPg
         ZjvcxcZeq7yLFyujSzRgDsUT3VlSGZxyUkoUqnAh2WTphfS6RTH6H7BIugKieGImed/3
         ekdN/k2zNv63KV+tgoixuVm5IvCm8KdWWXwSjPwT4aUF79po3DZMeUPyLWpHSe5G8FmH
         G/zBy19rAzyFCRWXX0qncBegn+2vOUFPsEDTR1QZ7UHaeK8FHQElOFW4JL5CfiABkmUP
         JnPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BkDvAde+xEB9EcrHYCd3LbwuRS92d6Mc0FVT1jwspM8=;
        b=wayz000ilWAMz5vIbo3yeauk1/9khI5LpX7gu2VF7ERaqIoJiXpZ5ASboHVdf96GCx
         WUP2AAOnxFAfRtgsVi/Wa90j+N1nvqbI20NgNfLd4wUvgotkB+yNruVZy+pgRaI0DO4u
         jvZO0fuPA0xj3L93ipSyCnituO0erTSMYN7bAKR6sz9fRHrbyz3jIed2vhrugvKTsTwS
         toGkTAWf/dBzaITOZVhvkXhbuVRlxNNe9Vwv6vsMfTHYD+0M8i3e3hgeAxdrX/JK1wPj
         qU2JVKPJZU7NrVTn97qX7WfVf7m1bkKfui8wt2pWJj37A/OToriVdOqHC/XLTtlv4i3K
         T+cg==
X-Gm-Message-State: AO0yUKUXKbL268n/zyOW/Q4Wq4U1tfP1luv9kKgM1lmf/p/H5Cj79q2O
        AHcx3gnBGRKLB4kv2xqFTOMoViQKYwjhzw==
X-Google-Smtp-Source: AK7set/0oI6mOIAcKW1VboXRgJ4t1fzTNFzHLjDgu+zbEp/gMciwOtoFgR7uBdNNvXWUCinDZ2m222zM71NuvQ==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:209:cf33:dc28:3e98:f5e9])
 (user=maennich job=sendgmr) by 2002:a25:9109:0:b0:87e:a15b:4e55 with SMTP id
 v9-20020a259109000000b0087ea15b4e55mr6271ybl.21.1677153234779; Thu, 23 Feb
 2023 03:53:54 -0800 (PST)
Date:   Thu, 23 Feb 2023 11:53:47 +0000
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
Message-Id: <20230223115351.1241401-1-maennich@google.com>
Mime-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH v5.15 v2 0/4] Allow CONFIG_DEBUG_INFO_DWARF5=y + CONFIG_DEBUG_INFO_BTF=y
From:   Matthias Maennich <maennich@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

Can we please pick up the essential parts of this series for 5.15? I am
particularly interested in the last patch to enable BTF + DWARF5, but
the cleanup patches before are a very reasonable choice for stable@ as
well as they simplify the pahole version calculation and allow future
BTF/pahole related patches to apply cleanly as well.

Cheers,
Matthias

Cc: <stable@vger.kernel.org> # v5.15+
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Matthias Maennich <maennich@google.com>

Nathan Chancellor (4):
  kbuild: Add CONFIG_PAHOLE_VERSION
  scripts/pahole-flags.sh: Use pahole-version.sh
  lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
  lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+

 MAINTAINERS               |  1 +
 init/Kconfig              |  4 ++++
 lib/Kconfig.debug         |  4 ++--
 scripts/pahole-flags.sh   |  2 +-
 scripts/pahole-version.sh | 13 +++++++++++++
 5 files changed, 21 insertions(+), 3 deletions(-)
 create mode 100755 scripts/pahole-version.sh

-- 
2.39.2.637.g21b0678d19-goog

