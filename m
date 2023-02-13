Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F766949C7
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjBMPCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjBMPBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:01:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F291F1E298
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:01:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 450766115A
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC0CC433D2;
        Mon, 13 Feb 2023 15:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300484;
        bh=MR/kAdflOEhns2wWlMYM/lsSbRZCkzPNXCRCtKITWiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWbRe+w+/U26obRt08D3R6DEEP14bI+XQ8Y79JYNa+q5hwG16v2mjIT50LZA/kzse
         uCiFcPSeUcpgBASWK+mOyKo/T79AetGVBIUFdyz/2eciQsjvHZxleI0bRUN/sn7bSi
         b4hmja3mOGjkGEg0ftn8JQ3IdlE8jS3JNupgVcCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andrei Gherzan <andrei.gherzan@canonical.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/139] selftests: net: udpgso_bench_rx/tx: Stop when wrong CLI args are provided
Date:   Mon, 13 Feb 2023 15:49:36 +0100
Message-Id: <20230213144747.288990922@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Gherzan <andrei.gherzan@canonical.com>

[ Upstream commit db9b47ee9f5f375ab0c5daeb20321c75b4fa657d ]

Leaving unrecognized arguments buried in the output, can easily hide a
CLI/script typo. Avoid this by exiting when wrong arguments are provided to
the udpgso_bench test programs.

Fixes: 3a687bef148d ("selftests: udp gso benchmark")
Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20230201001612.515730-2-andrei.gherzan@canonical.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 2 ++
 tools/testing/selftests/net/udpgso_bench_tx.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index d0895bd1933f..4058c7451e70 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -336,6 +336,8 @@ static void parse_opts(int argc, char **argv)
 			cfg_verify = true;
 			cfg_read_all = true;
 			break;
+		default:
+			exit(1);
 		}
 	}
 
diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index f1fdaa270291..b47b5c32039f 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -490,6 +490,8 @@ static void parse_opts(int argc, char **argv)
 		case 'z':
 			cfg_zerocopy = true;
 			break;
+		default:
+			exit(1);
 		}
 	}
 
-- 
2.39.0



