Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654A94BDDED
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348164AbiBUJOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:14:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348864AbiBUJLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:11:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33C228988;
        Mon, 21 Feb 2022 01:04:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE4160FB6;
        Mon, 21 Feb 2022 09:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FBDC340E9;
        Mon, 21 Feb 2022 09:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434256;
        bh=w7C2GgCRtP1+xltsNW+WDszYMEqhmA+wflbrN7qr1Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dxdk/+52oV79MA/rMQ/vjSa3m6L4MXCIlAgTjNuVNDK21DTPM+cATWEYl5b05KHnm
         +KgJQkxRuL/gWNUSiIZ7i83urF2tstKWB/zZC6vSLuJ66s7PNsfR1yp4wAFgjzq1jV
         ARUNZsgFKRdYN0ZaY6G9Ab01dvclps1q9xU6lPTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 067/121] perf bpf: Defer freeing string after possible strlen() on it
Date:   Mon, 21 Feb 2022 09:49:19 +0100
Message-Id: <20220221084923.467669276@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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
@@ -1215,9 +1215,10 @@ bpf__obj_config_map(struct bpf_object *o
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
 


