Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7E55317C2
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbiEWR36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241696AbiEWR1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF75373574;
        Mon, 23 May 2022 10:22:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51057B81210;
        Mon, 23 May 2022 17:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6ECC385A9;
        Mon, 23 May 2022 17:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326488;
        bh=2QNI6p3DCQnj328K6ybIE7IWGu/SDS5fAgkPESIDXyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jr7xFsRGkFizGD41waYYOZlNvMot2hr3YyV3BaRHoCXR/lotoe1YfLO5WEFEKzdbC
         p4CDLNLEoGuiDjd70hz0tW0It1pBVjPwN5edrqHxzuVF3KufF5heazlWWOg9Lh9eL6
         zG2OjNoJVeRJ/bjII3uOQIfpMd6+GJ3g0dnXXIhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/132] mptcp: reuse __mptcp_make_csum in validate_data_csum
Date:   Mon, 23 May 2022 19:05:05 +0200
Message-Id: <20220523165839.281588719@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

[ Upstream commit 8401e87f5a36d370cbf1e9d4ba602a553ce9324a ]

This patch reused __mptcp_make_csum() in validate_data_csum() instead of
open-coding.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6172f380dfb7..04afead7316f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -845,9 +845,8 @@ static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *
 					      bool csum_reqd)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
-	struct csum_pseudo_header header;
 	u32 offset, seq, delta;
-	__wsum csum;
+	u16 csum;
 	int len;
 
 	if (!csum_reqd)
@@ -908,13 +907,11 @@ static enum mapping_status validate_data_csum(struct sock *ssk, struct sk_buff *
 	 * while the pseudo header requires the original DSS data len,
 	 * including that
 	 */
-	header.data_seq = cpu_to_be64(subflow->map_seq);
-	header.subflow_seq = htonl(subflow->map_subflow_seq);
-	header.data_len = htons(subflow->map_data_len + subflow->map_data_fin);
-	header.csum = 0;
-
-	csum = csum_partial(&header, sizeof(header), subflow->map_data_csum);
-	if (unlikely(csum_fold(csum))) {
+	csum = __mptcp_make_csum(subflow->map_seq,
+				 subflow->map_subflow_seq,
+				 subflow->map_data_len + subflow->map_data_fin,
+				 subflow->map_data_csum);
+	if (unlikely(csum)) {
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DATACSUMERR);
 		subflow->send_mp_fail = 1;
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPFAILTX);
-- 
2.35.1



