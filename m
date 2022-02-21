Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BE04BE7F6
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349691AbiBUJ2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:28:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348931AbiBUJ1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35461657B;
        Mon, 21 Feb 2022 01:12:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A5FB7CE0E88;
        Mon, 21 Feb 2022 09:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B13C340E9;
        Mon, 21 Feb 2022 09:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434724;
        bh=08eY0msXADLduerMwecp2drQdDRqyeIrBiLp/rfWPzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ia6VvZcy3V/v2AY31FRlV2fIS0FTzLT1cz2Pm7WweTw4Xm8Oao+Rank+xGIt0wCRc
         SSY9Yj7/XV8F+gfFEE5xYri0BctuukJ8oB6/8UYNPgFZ333lRYcQlEwXiyXNSUF045
         BKAIXKb+XKyiu54+Mf0MegDMpYYYIbbOFPfZLodc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 108/196] perf bpf: Defer freeing string after possible strlen() on it
Date:   Mon, 21 Feb 2022 09:49:00 +0100
Message-Id: <20220221084934.551769405@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 31ded1535e3182778a1d0e5c32711f55da3bc512 upstream.

This was detected by the gcc in Fedora Rawhide's gcc:

  50    11.01 fedora:rawhide                : FAIL gcc version 12.0.1 20220205 (Red Hat 12.0.1-0) (GCC)
        inlined from 'bpf__config_obj' at util/bpf-loader.c:1242:9:
    util/bpf-loader.c:1225:34: error: pointer 'map_opt' may be used after 'free' [-Werror=use-after-free]
     1225 |                 *key_scan_pos += strlen(map_opt);
          |                                  ^~~~~~~~~~~~~~~
    util/bpf-loader.c:1223:9: note: call to 'free' here
     1223 |         free(map_name);
          |         ^~~~~~~~~~~~~~
    cc1: all warnings being treated as errors

So do the calculations on the pointer before freeing it.

Fixes: 04f9bf2bac72480c ("perf bpf-loader: Add missing '*' for key_scan_pos")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang ShaoBo <bobo.shaobowang@huawei.com>
Link: https://lore.kernel.org/lkml/Yg1VtQxKrPpS3uNA@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/bpf-loader.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/perf/util/bpf-loader.c
+++ b/tools/perf/util/bpf-loader.c
@@ -1214,9 +1214,10 @@ bpf__obj_config_map(struct bpf_object *o
 	pr_debug("ERROR: Invalid map config option '%s'\n", map_opt);
 	err = -BPF_LOADER_ERRNO__OBJCONF_MAP_OPT;
 out:
-	free(map_name);
 	if (!err)
 		*key_scan_pos += strlen(map_opt);
+
+	free(map_name);
 	return err;
 }
 


