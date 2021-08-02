Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1509F3DD9E2
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhHBOFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236346AbhHBOCK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:02:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD2E3611ED;
        Mon,  2 Aug 2021 13:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912616;
        bh=LInH/tI0eUELG0RI9th8yJ+JRNq+nK7IMp+t/D13LGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CseNrlxP5lEtZPFJDXQvg/KyAwQx1/R5x7/6s/fw1qAKU1RJDHEFPJB4qDGBANebK
         Bai9zvAuadigkbyWB3hJ+1U91q4nJiUAtxtkZzQfB9GWTiyJyBrnDE1ON7OHSgUImt
         rzCIm7Wz3neMi4VqckR3yQZoJ7NvIUKgX9Vjuc6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 073/104] KVM: selftests: Fix missing break in dirty_log_perf_test arg parsing
Date:   Mon,  2 Aug 2021 15:45:10 +0200
Message-Id: <20210802134346.420213869@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Matlack <dmatlack@google.com>

[ Upstream commit 15b7b737deb30e1f8f116a08e723173b55ebd2f3 ]

There is a missing break statement which causes a fallthrough to the
next statement where optarg will be null and a segmentation fault will
be generated.

Fixes: 9e965bb75aae ("KVM: selftests: Add backing src parameter to dirty_log_perf_test")
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20210713220957.3493520-6-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 04a2641261be..80cbd3a748c0 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -312,6 +312,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'o':
 			p.partition_vcpu_memory_access = false;
+			break;
 		case 's':
 			p.backing_src = parse_backing_src_type(optarg);
 			break;
-- 
2.30.2



