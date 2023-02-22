Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852DA69F35D
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 12:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjBVLW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 06:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjBVLWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 06:22:25 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD3432E49
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:22:24 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536bbaeceeaso67365747b3.11
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0net9U3CbYNje/Gglte/4WW6u4hogiAk1dLkHGk2bt8=;
        b=XQpkBrCc23TUNlKWVQ5NlL4ZCYp0Qsh/OjHjcGcJSldg54UNIA1tIqvXmJRbVDPfpW
         rQGg0zGwY77N+S1d96M65QDedGFVsq0a5v4LkuP0LyGpdrOpCsWG3CF7yr6+Z1rDRGng
         9E3dq1D2dorSht0OGkXZ1LY6ZxJs5ZwDF2acIx+P3UY7ygj/4jKjbBRALT3kiSF20ZUv
         dt8X/UXPbXP+6TUnef896CmgLti2Ff17tEPqyGrsqcFWkAKx3aZ9XFhxLrj+UfOUoGt5
         w35k1OQWtstInhWHxSbEMTzzU+PES30Qxuea4+BK3yhBgss4qNaS0yypA8VLtd6B3MzK
         ZpWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0net9U3CbYNje/Gglte/4WW6u4hogiAk1dLkHGk2bt8=;
        b=Z5/iF8nucc852cpMNKkoiQKLYeI9m/F21V/bJzpts81Cl5F3rpONHUVcD7ezSl4SsI
         ZYTWOIIQs/vy3ci0qvHOja4SOz0R1NIVge2Ye7YnI3ANpE8/L6jXjg2iV9AKqq7I4Rh3
         wazafNJzwcqKqawGxAzRGRLmBn0+te3MwwawsQ2SlhFn/QpFVdFw3uAbBPd6Vh8BfCzQ
         ojZfs85EZ3s8oq5AHo8mm14gSALMpdXBhJU1iUSG39kZG47XjhPdWK6KJRy3Fvknn8wN
         MoDbiavE7cCISh5UqH7WHYuNOmI9S6d92q0pHden/bJUF/h/14UyDJoF+JHL4aMgC36D
         vaMw==
X-Gm-Message-State: AO0yUKWJh+4xDtJtP2AsnUute0zHfqjQUCId30e2SZozi++uRY7SQeoR
        VnvXTuiNG4Bd7n4C1rIibpZ6NnuSBv47/A==
X-Google-Smtp-Source: AK7set+uyXY/IYoT+WfH5P06v11Y1dLs4HWBdjX7R6Sv+pg5qFfgnE+fearbv2O86j4e2l0Qk7bCJASrB5JkYg==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:209:35a9:4800:d90c:e9bc])
 (user=maennich job=sendgmr) by 2002:a05:6902:1024:b0:8da:3163:224 with SMTP
 id x4-20020a056902102400b008da31630224mr1005683ybt.0.1677064943540; Wed, 22
 Feb 2023 03:22:23 -0800 (PST)
Date:   Wed, 22 Feb 2023 11:21:37 +0000
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
Message-Id: <20230222112141.278066-1-maennich@google.com>
Mime-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH 0/5] Allow CONFIG_DEBUG_INFO_DWARF5=y + CONFIG_DEBUG_INFO_BTF=y
From:   maennich@google.com
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

From: Matthias Maennich <maennich@google.com>

Can we please pick this series up for 5.15? I am particularly interested
in the last patch to enable BTF + DWARF5, but the cleanup patches before
are a very reasonable choice for stable@ as well as they simplify the
pahole version calculation and allow future BTF/pahole related patches
to apply cleanly as well. I intentionally kept the config
PAHOLE_HAS_BTF_TAG and hence its patch complete, even though there is no
user for it.

Cheers,
Matthias

Cc: <stable@vger.kernel.org> # v5.15+
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Matthias Maennich <maennich@google.com>

Nathan Chancellor (5):
  MAINTAINERS: Add scripts/pahole-flags.sh to BPF section
  kbuild: Add CONFIG_PAHOLE_VERSION
  scripts/pahole-flags.sh: Use pahole-version.sh
  lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
  lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+

 MAINTAINERS               |  2 ++
 init/Kconfig              |  4 ++++
 lib/Kconfig.debug         | 12 ++++++++++--
 scripts/pahole-flags.sh   |  2 +-
 scripts/pahole-version.sh | 13 +++++++++++++
 5 files changed, 30 insertions(+), 3 deletions(-)
 create mode 100755 scripts/pahole-version.sh

-- 
2.39.2.637.g21b0678d19-goog

