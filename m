Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FB91DEB25
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbgEVOuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730412AbgEVOuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:50:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A09B2245A;
        Fri, 22 May 2020 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159015;
        bh=oqZ+NsD3VxSpXbZh521LmVgD1/qZripK/UNHLLtpTDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yT7ZvSxnqlWwIiFmHZMMcfz3iyX+NIRUSj77j/4iv7XOIOlW+pif8hzifl8FeTnMH
         INI9h5+jTa6Tb7FyZ+4X6D30oA3ImoBzBbjdnDyQSnljeRaW8EBE9KH3ZFyVyKY2MM
         r9byD29gIsyUTEGZKYBImuJB235CqoVS99xA8qds=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Brian Starkey <brian.starkey@arm.com>,
        Laura Abbott <labbott@redhat.com>,
        "Andrew F. Davis" <afd@ti.com>, linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 13/41] kselftests: dmabuf-heaps: Fix confused return value on expected error testing
Date:   Fri, 22 May 2020 10:49:30 -0400
Message-Id: <20200522144959.434379-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522144959.434379-1-sashal@kernel.org>
References: <20200522144959.434379-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

[ Upstream commit 4bb9d46d47b105a774f9dca642f5271375bca4b2 ]

When I added the expected error testing, I forgot I need to set
the return to zero when we successfully see an error.

Without this change we only end up testing a single heap
before the test quits.

Cc: Shuah Khan <shuah@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Brian Starkey <brian.starkey@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: "Andrew F. Davis" <afd@ti.com>
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
index cd5e1f602ac9..909da9cdda97 100644
--- a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
+++ b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
@@ -351,6 +351,7 @@ static int test_alloc_errors(char *heap_name)
 	}
 
 	printf("Expected error checking passed\n");
+	ret = 0;
 out:
 	if (dmabuf_fd >= 0)
 		close(dmabuf_fd);
-- 
2.25.1

