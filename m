Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CDE41264F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355223AbhITS4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384654AbhITSsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D26B6337F;
        Mon, 20 Sep 2021 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159255;
        bh=ocT6c1jhHQBjdp3TAMdERgGoc6Sxjjr/tVGyR5mrRgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=teejxA5dgCI+EEJ6xoDMGGIq2/r6Y21R+GiX01KMuYrdd5xtD2nrNwmyQyrldzHiC
         2w5wwQrMOjkLO+Ws2R7/hYg0QZx3WbeIDGsw+djQ2UZFYvGk6zgTOniAUtAUbYY5NF
         QYVw7wyObZPfiu2vCrKQiYOPhdyJE0tgb3kXFXv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 148/168] tools build: Fix feature detect clean for out of source builds
Date:   Mon, 20 Sep 2021 18:44:46 +0200
Message-Id: <20210920163926.522631543@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Clark <james.clark@arm.com>

[ Upstream commit 8af52e69772d053bc7caab12ad1c59f18ef2e3e2 ]

Currently the clean target when using O= isn't cleaning the feature
detect output. This is because O= and OUTPUT= are set to canonical
paths. For example in tools/perf/Makefile:

  FULL_O := $(shell cd $(PWD); readlink -f $(O) || echo $(O))

This means that OUTPUT ends in a / and most usages prepend it to a file
without adding an extra /. This line that was changed adds an extra /
before the 'feature' folder but not to the end, resulting in a clean
command like this:

  rm -f /tmp/build//featuretest-all.bin ...

After the change the clean command looks like this:

  rm -f /tmp/build/feature/test-all.bin ...

Fixes: 762323eb39a257c3 ("perf build: Move feature cleanup under tools/build")
Signed-off-by: James Clark <james.clark@arm.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: http://lore.kernel.org/lkml/20210816130705.1331868-1-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/build/Makefile b/tools/build/Makefile
index 5ed41b96fcde..6f11e6fc9ffe 100644
--- a/tools/build/Makefile
+++ b/tools/build/Makefile
@@ -32,7 +32,7 @@ all: $(OUTPUT)fixdep
 
 # Make sure there's anything to clean,
 # feature contains check for existing OUTPUT
-TMP_O := $(if $(OUTPUT),$(OUTPUT)/feature,./)
+TMP_O := $(if $(OUTPUT),$(OUTPUT)feature/,./)
 
 clean:
 	$(call QUIET_CLEAN, fixdep)
-- 
2.30.2



