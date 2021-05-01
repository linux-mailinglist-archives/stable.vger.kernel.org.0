Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCFA370856
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 20:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhEASGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 14:06:01 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:16286 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbhEASGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 14:06:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619892311; x=1651428311;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zO583Op+nxsi5F+dNCQ8H2aI7hYSqo8uIwOIw2iXZhE=;
  b=imd3eN6msLGUByohn7Xo3I8Q4AUKyBcw4yGyhhD3ji2f2DJozn+9YKCb
   QrB8+m6pBEGsgW6eB8q1jMCCEVDNWzcf/pbB031P7GucYY2pKEjCzaPVy
   F8/1y+KtMZyBVxhg7gAAWN8G7P7s0j83EFoUqE9zpv7LmphAgTEwZ5QHT
   c=;
X-IronPort-AV: E=Sophos;i="5.82,266,1613433600"; 
   d="scan'208";a="111013691"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-16425a8d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 01 May 2021 18:05:10 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-16425a8d.us-east-1.amazon.com (Postfix) with ESMTPS id 6B471100AB0;
        Sat,  1 May 2021 18:05:09 +0000 (UTC)
Received: from EX13D01UWA003.ant.amazon.com (10.43.160.107) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 18:05:09 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13d01UWA003.ant.amazon.com (10.43.160.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 May 2021 18:05:08 +0000
Received: from dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com
 (172.19.206.175) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Sat, 1 May 2021 18:05:07 +0000
Received: by dev-dsk-fllinden-2c-d7720709.us-west-2.amazon.com (Postfix, from userid 6262777)
        id 25A98978; Sat,  1 May 2021 18:05:06 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <samjonas@amazon.com>
Subject: [PATCH 4.14 0/2] fix BPF backports
Date:   Sat, 1 May 2021 18:05:04 +0000
Message-ID: <20210501180506.19154-1-fllinden@amazon.com>
X-Mailer: git-send-email 2.23.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These are the first two patches in https://lore.kernel.org/stable/20210501043014.33300-1-fllinden@amazon.com/

I will re-send the rest of that series as soon as the other bpf backports
hit the 4.19 branch.

This fixes errors in earlier bpf 4.14 backports. The verifier fix was
sent in earlier to bpf@ by Sam, and acked. I added the selftests
fix.

Essentially, together with the previous backports that had errors,
this produces correct backports of:

9d7eceede76 ("bpf: restrict unknown scalars of mixed signed bounds for
unprivileged")
80c9b2fae87b ("bpf: add various test cases to selftests")

Commits:

<4.14 only> ("bpf: Fix backport of "bpf: restrict unknown scalars of mixed signed bounds for unprivileged")
	This was sent in by Sam to bpf@ earlier, and acked by Yonghong Song,
	https://lore.kernel.org/bpf/20210419235641.5442-1-samjonas@amazon.com/T/#u

	I am including it so that it is 'formally' submitted it
	to -stable.

<4.14 only> ("bpf: fix up selftests after backports were fixed")
	This is a follow-up to the previous by me, to fix selftests. It's
	from 80c9b2fae87b ("bpf: add various test cases to selftests"), but
	since that one was already partially added to the 4.14 branch
	in 03f11a51a196 ("bpf: Fix selftests are changes for CVE 2019-7308"),
	it's not a "backport" as such. To avoid confusion, I created a
	separate commit for it, referencing the original commit
	in the message. I examined each individual changed test, and
	went through the history to see that the error message was indeed
	as expected.
