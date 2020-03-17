Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C09BC187F14
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgCQK6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727201AbgCQK6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:58:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2808420719;
        Tue, 17 Mar 2020 10:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442699;
        bh=CJWOWQa3hIlsT45lEVBrSR3FnQYkMwvvDTbOn39maNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvlyABBPlMQPGhKIirIg45cGJGiDJMdtjjH8ORZOvf0OurzyTHqwciiZh02sfON2D
         X5mLhqOqQyErsn7DPaLWwqzXgyvYOTWC5aF21ACNPaS8BTnTHpFycFWqnKrsS5PILW
         U0dP3sdSxaiRd7CpvYaNHaVuotH6dRHdB6qDY1YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 51/89] netfilter: nf_conntrack: ct_cpu_seq_next should increase position index
Date:   Tue, 17 Mar 2020 11:55:00 +0100
Message-Id: <20200317103305.791797399@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit dc15af8e9dbd039ebb06336597d2c491ef46ab74 upstream.

If .next function does not change position index,
following .show function will repeat output related
to current position index.

Cc: stable@vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_standalone.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -390,7 +390,7 @@ static void *ct_cpu_seq_next(struct seq_
 		*pos = cpu + 1;
 		return per_cpu_ptr(net->ct.stat, cpu);
 	}
-
+	(*pos)++;
 	return NULL;
 }
 


