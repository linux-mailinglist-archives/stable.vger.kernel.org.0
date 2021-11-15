Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2F6450D8A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbhKOR73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239065AbhKOR5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:57:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73E4260EE9;
        Mon, 15 Nov 2021 17:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997678;
        bh=nosFUrgZVJO9waeAAJC7CGOmBp18rnYq8jhKm6CSv/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnC0vMC0/UGMG9ENcHyJVcYFitwh0YrpVTUouu0vItpl/mX6xxS9SZ3HiBy74DLao
         Vbsprg4PuSGkBaQciMFP0YPjha+QYCz8oTmWeTze/Bc6Wydq84dfzMNXF+QPgYuTIp
         FC0WRqSbEKzXyU75KAbMGBEv0HAiAg4qBf0zYb6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/575] selftests: kvm: fix mismatched fclose() after popen()
Date:   Mon, 15 Nov 2021 17:59:20 +0100
Message-Id: <20211115165351.862026051@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit c3867ab5924b7a9a0b4a117902a08669d8be7c21 ]

get_warnings_count() does fclose() using File * returned from popen().
Fix it to call pclose() as it should.

tools/testing/selftests/kvm/x86_64/mmio_warning_test
x86_64/mmio_warning_test.c: In function ‘get_warnings_count’:
x86_64/mmio_warning_test.c:87:9: warning: ‘fclose’ called on pointer returned from a mismatched allocation function [-Wmismatched-dealloc]
   87 |         fclose(f);
      |         ^~~~~~~~~
x86_64/mmio_warning_test.c:84:13: note: returned from ‘popen’
   84 |         f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/x86_64/mmio_warning_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
index 8039e1eff9388..9f55ccd169a13 100644
--- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
@@ -84,7 +84,7 @@ int get_warnings_count(void)
 	f = popen("dmesg | grep \"WARNING:\" | wc -l", "r");
 	if (fscanf(f, "%d", &warnings) < 1)
 		warnings = 0;
-	fclose(f);
+	pclose(f);
 
 	return warnings;
 }
-- 
2.33.0



