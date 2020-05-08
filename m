Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9751CAF14
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgEHNOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728365AbgEHMrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B58C22145D;
        Fri,  8 May 2020 12:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942036;
        bh=2hNUwwDf2Ia5fvc6hr/O4FylkL379FZKlUpR4j/MaSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttoJELWeu6FskRIzIcuuTmbu3WMITnxngR1SRz/glPkGsxXB/iHFq8RyIV0fsNOJK
         2HsaEk8JgGz6UfKj9P+cUVCCg1DsZaH59FdQaTDxSU/hf1A4VtL9b5Cwllm0Y6VlYm
         KaxjUnxKhLKd2dpDaPoKJ6ldOL4f8batgkvdL3V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 269/312] fq_codel: return non zero qlen in class dumps
Date:   Fri,  8 May 2020 14:34:20 +0200
Message-Id: <20200508123143.352128332@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit aafddbf0cffeb790f919436285328c762279b5d4 upstream.

We properly scan the flow list to count number of packets,
but John passed 0 to gnet_stats_copy_queue() so we report
a zero value to user space instead of the result.

Fixes: 640158536632 ("net: sched: restrict use of qstats qlen")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.r.fastabend@intel.com>
Acked-by: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/sch_fq_codel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -588,7 +588,7 @@ static int fq_codel_dump_class_stats(str
 		qs.backlog = q->backlogs[idx];
 		qs.drops = flow->dropped;
 	}
-	if (gnet_stats_copy_queue(d, NULL, &qs, 0) < 0)
+	if (gnet_stats_copy_queue(d, NULL, &qs, qs.qlen) < 0)
 		return -1;
 	if (idx < q->flows_cnt)
 		return gnet_stats_copy_app(d, &xstats, sizeof(xstats));


