Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109CB5290FB
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346653AbiEPUHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349539AbiEPUAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF186427F5;
        Mon, 16 May 2022 12:54:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58E0AB81612;
        Mon, 16 May 2022 19:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA37C385AA;
        Mon, 16 May 2022 19:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730839;
        bh=tvt3VPT3sUjfD+Yw/+5I3ea0kxUmHKnrj4n+CmedKmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skw6uXvLDQEh8si1S+1+Ad4hPIMRA0SMdMn0FOO6cq8x4ICYSlacen8P0cJNdhgFH
         UL6fL0L0vuDGIgB1bdw072D4mYCtQ+s/klk8GxHmjQpHW14RQ7VrFXiLPDVBORf0HC
         z28tNF+3sPNGLeSY03sVPWtHebQRbE2zM4HfYTQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 021/114] net: chelsio: cxgb4: Avoid potential negative array offset
Date:   Mon, 16 May 2022 21:35:55 +0200
Message-Id: <20220516193626.103551273@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 1c7ab9cd98b78bef1657a5db7204d8d437e24c94 ]

Using min_t(int, ...) as a potential array index implies to the compiler
that negative offsets should be allowed. This is not the case, though.
Replace "int" with "unsigned int". Fixes the following warning exposed
under future CONFIG_FORTIFY_SOURCE improvements:

In file included from include/linux/string.h:253,
                 from include/linux/bitmap.h:11,
                 from include/linux/cpumask.h:12,
                 from include/linux/smp.h:13,
                 from include/linux/lockdep.h:14,
                 from include/linux/rcupdate.h:29,
                 from include/linux/rculist.h:11,
                 from include/linux/pid.h:5,
                 from include/linux/sched.h:14,
                 from include/linux/delay.h:23,
                 from drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:35:
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c: In function 't4_get_raw_vpd_params':
include/linux/fortify-string.h:46:33: warning: '__builtin_memcpy' pointer overflow between offset 29 and size [2147483648, 4294967295] [-Warray-bounds]
   46 | #define __underlying_memcpy     __builtin_memcpy
      |                                 ^
include/linux/fortify-string.h:388:9: note: in expansion of macro '__underlying_memcpy'
  388 |         __underlying_##op(p, q, __fortify_size);                        \
      |         ^~~~~~~~~~~~~
include/linux/fortify-string.h:433:26: note: in expansion of macro '__fortify_memcpy_chk'
  433 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
      |                          ^~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:2796:9: note: in expansion of macro 'memcpy'
 2796 |         memcpy(p->id, vpd + id, min_t(int, id_len, ID_LEN));
      |         ^~~~~~
include/linux/fortify-string.h:46:33: warning: '__builtin_memcpy' pointer overflow between offset 0 and size [2147483648, 4294967295] [-Warray-bounds]
   46 | #define __underlying_memcpy     __builtin_memcpy
      |                                 ^
include/linux/fortify-string.h:388:9: note: in expansion of macro '__underlying_memcpy'
  388 |         __underlying_##op(p, q, __fortify_size);                        \
      |         ^~~~~~~~~~~~~
include/linux/fortify-string.h:433:26: note: in expansion of macro '__fortify_memcpy_chk'
  433 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
      |                          ^~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:2798:9: note: in expansion of macro 'memcpy'
 2798 |         memcpy(p->sn, vpd + sn, min_t(int, sn_len, SERNUM_LEN));
      |         ^~~~~~

Additionally remove needless cast from u8[] to char * in last strim()
call.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/202205031926.FVP7epJM-lkp@intel.com
Fixes: fc9279298e3a ("cxgb4: Search VPD with pci_vpd_find_ro_info_keyword()")
Fixes: 24c521f81c30 ("cxgb4: Use pci_vpd_find_id_string() to find VPD ID string")
Cc: Raju Rangoju <rajur@chelsio.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220505233101.1224230-1-keescook@chromium.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index e7b4e3ed056c..8d719f82854a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2793,14 +2793,14 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 		goto out;
 	na = ret;
 
-	memcpy(p->id, vpd + id, min_t(int, id_len, ID_LEN));
+	memcpy(p->id, vpd + id, min_t(unsigned int, id_len, ID_LEN));
 	strim(p->id);
-	memcpy(p->sn, vpd + sn, min_t(int, sn_len, SERNUM_LEN));
+	memcpy(p->sn, vpd + sn, min_t(unsigned int, sn_len, SERNUM_LEN));
 	strim(p->sn);
-	memcpy(p->pn, vpd + pn, min_t(int, pn_len, PN_LEN));
+	memcpy(p->pn, vpd + pn, min_t(unsigned int, pn_len, PN_LEN));
 	strim(p->pn);
-	memcpy(p->na, vpd + na, min_t(int, na_len, MACADDR_LEN));
-	strim((char *)p->na);
+	memcpy(p->na, vpd + na, min_t(unsigned int, na_len, MACADDR_LEN));
+	strim(p->na);
 
 out:
 	vfree(vpd);
-- 
2.35.1



