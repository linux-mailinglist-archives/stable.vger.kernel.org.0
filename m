Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A53E3E2522
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbhHFIR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243950AbhHFIQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:16:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8E5261131;
        Fri,  6 Aug 2021 08:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237766;
        bh=PJ6/zxTC8Mn7GwXEaqQrv+z0feG7G9QlJpaZhGP4T6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eC3I84weJaKG63tZoVzo0WAtJhc9p+NcS1+37DWGgan3rbEiJ0kZxlPvK3YPCzmrv
         ixXMi7UBj96Q+9mJQQ1ipJXWt8ex5oXkQOB67/T0xNfnsgCfytQCCToBySlTyjfKhB
         NGmb8yn84k8wBYRhFNgGnNP3tuxTfq3d/XpoFhx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 4.19 12/16] drm/i915: Ensure intel_engine_init_execlist() builds with Clang
Date:   Fri,  6 Aug 2021 10:15:03 +0200
Message-Id: <20210806081111.537230464@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081111.144943357@linuxfoundation.org>
References: <20210806081111.144943357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

commit 410ed5731a6566498a3aa904420aa2e49ba0ba90 upstream.

Clang build with UBSAN enabled leads to the following build error:

drivers/gpu/drm/i915/intel_engine_cs.o: In function `intel_engine_init_execlist':
drivers/gpu/drm/i915/intel_engine_cs.c:411: undefined reference to `__compiletime_assert_411'

Again, for this to work the code would first need to be inlined and then
constant folded, which doesn't work for Clang because semantic analysis
happens before optimization/inlining.

Use GEM_BUG_ON() instead of BUILD_BUG_ON().

v2: Use is_power_of_2() from log2.h (Chris)

Reported-by: Stephen Boyd <swboyd@chromium.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20181016122938.18757-2-jani.nikula@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_engine_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/intel_engine_cs.c
@@ -463,7 +463,7 @@ static void intel_engine_init_execlist(s
 	struct intel_engine_execlists * const execlists = &engine->execlists;
 
 	execlists->port_mask = 1;
-	BUILD_BUG_ON_NOT_POWER_OF_2(execlists_num_ports(execlists));
+	GEM_BUG_ON(!is_power_of_2(execlists_num_ports(execlists)));
 	GEM_BUG_ON(execlists_num_ports(execlists) > EXECLIST_MAX_PORTS);
 
 	execlists->queue_priority = INT_MIN;


