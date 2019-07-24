Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14ECC73DDC
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390167AbfGXTq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391067AbfGXTq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:46:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9378F21873;
        Wed, 24 Jul 2019 19:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997587;
        bh=qsTdb3uLDLhoenYJTJ6XqMcSH5cJK+RdRtzxtyViy8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbHV+6nCed/Y5WWjB3sw/dU6ngcmmfvqroV7Ds7v3fvMqpOo7hiuLd/ZJU2g7RIge
         1BtHpXnp/qil6DT6eW/Wu2w5fFw0w8pTZCoO/CMFuFZzIO/KwZWuQBXHB1e+iD9OBi
         oZR2TGskcblkLCYdWTM+aFV4+2slHFC72G3BulTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NOYB <JunkYardMail1@Frontier.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 072/371] ipset: Fix memory accounting for hash types on resize
Date:   Wed, 24 Jul 2019 21:17:04 +0200
Message-Id: <20190724191730.298685371@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 11921796f4799ca9c61c4b22cc54d84aa69f8a35 ]

If a fresh array block is allocated during resize, the current in-memory
set size should be increased by the size of the block, not replaced by it.

Before the fix, adding entries to a hash set type, leading to a table
resize, caused an inconsistent memory size to be reported. This becomes
more obvious when swapping sets with similar sizes:

  # cat hash_ip_size.sh
  #!/bin/sh
  FAIL_RETRIES=10

  tries=0
  while [ ${tries} -lt ${FAIL_RETRIES} ]; do
  	ipset create t1 hash:ip
  	for i in `seq 1 4345`; do
  		ipset add t1 1.2.$((i / 255)).$((i % 255))
  	done
  	t1_init="$(ipset list t1|sed -n 's/Size in memory: \(.*\)/\1/p')"

  	ipset create t2 hash:ip
  	for i in `seq 1 4360`; do
  		ipset add t2 1.2.$((i / 255)).$((i % 255))
  	done
  	t2_init="$(ipset list t2|sed -n 's/Size in memory: \(.*\)/\1/p')"

  	ipset swap t1 t2
  	t1_swap="$(ipset list t1|sed -n 's/Size in memory: \(.*\)/\1/p')"
  	t2_swap="$(ipset list t2|sed -n 's/Size in memory: \(.*\)/\1/p')"

  	ipset destroy t1
  	ipset destroy t2
  	tries=$((tries + 1))

  	if [ ${t1_init} -lt 10000 ] || [ ${t2_init} -lt 10000 ]; then
  		echo "FAIL after ${tries} tries:"
  		echo "T1 size ${t1_init}, after swap ${t1_swap}"
  		echo "T2 size ${t2_init}, after swap ${t2_swap}"
  		exit 1
  	fi
  done
  echo "PASS"
  # echo -n 'func hash_ip4_resize +p' > /sys/kernel/debug/dynamic_debug/control
  # ./hash_ip_size.sh
  [ 2035.018673] attempt to resize set t1 from 10 to 11, t 00000000fe6551fa
  [ 2035.078583] set t1 resized from 10 (00000000fe6551fa) to 11 (00000000172a0163)
  [ 2035.080353] Table destroy by resize 00000000fe6551fa
  FAIL after 4 tries:
  T1 size 9064, after swap 71128
  T2 size 71128, after swap 9064

Reported-by: NOYB <JunkYardMail1@Frontier.com>
Fixes: 9e41f26a505c ("netfilter: ipset: Count non-static extension memory for userspace")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 2c9609929c71..455804456008 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -625,7 +625,7 @@ mtype_resize(struct ip_set *set, bool retried)
 					goto cleanup;
 				}
 				m->size = AHASH_INIT_SIZE;
-				extsize = ext_size(AHASH_INIT_SIZE, dsize);
+				extsize += ext_size(AHASH_INIT_SIZE, dsize);
 				RCU_INIT_POINTER(hbucket(t, key), m);
 			} else if (m->pos >= m->size) {
 				struct hbucket *ht;
-- 
2.20.1



