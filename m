Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73DA1D84F7
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731609AbgERSPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732063AbgERR7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:59:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3965120829;
        Mon, 18 May 2020 17:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824774;
        bh=LYnkbzWRGUvBQJvhBeZXcEQgk/vKF/VSHag50RwZuMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHqCU1tF8CmktJp/dwY0JBbLsVydg2rzZH7ZLm3iu/PrZ41XSO88rQyZH1/LQ4YMs
         mn1xMK7ncRrCdmvRQginr77HtXxeFYc5jNBvdJuR1+3Jpb1fSESKEISRXT31kmhoan
         sCb8sB67r1NEUCVEb2+O+QJA6itgkU/GGxLu0Jwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 5.4 146/147] selftest/bpf: fix backported test_select_reuseport selftest changes
Date:   Mon, 18 May 2020 19:37:49 +0200
Message-Id: <20200518173531.102047266@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

Fix up RET_IF as CHECK macro to make selftests compile again.

Fixes: b911c5e8686a ("selftests: bpf: Reset global state between reuseport test runs")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/test_select_reuseport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/bpf/test_select_reuseport.c
+++ b/tools/testing/selftests/bpf/test_select_reuseport.c
@@ -668,12 +668,12 @@ static void cleanup_per_test(void)
 
 	for (i = 0; i < NR_RESULTS; i++) {
 		err = bpf_map_update_elem(result_map, &i, &zero, BPF_ANY);
-		RET_IF(err, "reset elem in result_map",
+		CHECK(err, "reset elem in result_map",
 		       "i:%u err:%d errno:%d\n", i, err, errno);
 	}
 
 	err = bpf_map_update_elem(linum_map, &zero, &zero, BPF_ANY);
-	RET_IF(err, "reset line number in linum_map", "err:%d errno:%d\n",
+	CHECK(err, "reset line number in linum_map", "err:%d errno:%d\n",
 	       err, errno);
 
 	for (i = 0; i < REUSEPORT_ARRAY_SIZE; i++)


