Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19DF4C7464
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiB1RpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238683AbiB1Rmz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:42:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839C199ECB;
        Mon, 28 Feb 2022 09:35:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20609614AC;
        Mon, 28 Feb 2022 17:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A17C340E7;
        Mon, 28 Feb 2022 17:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069701;
        bh=4ssv4qucDRLkoQOkBmUQ+RTT/LFAQquKHJQzOIfWk9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIsoUkxz70HQnQO5JbaLpn+aK7Dr3Ry4pvLnetopKhT3Wlp9RdMxrWiIRKPu+Qa+c
         DuTzqwwYPVp7Uai8A1pVnymaF3xGFoGKJ7SYa+EK7cDTbYYVmxJDO4hXaE12AbHMDc
         wyrnBYNupdb9FoR012GUzlmvK2fKzLjy2Z+whM94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Brian Vazquez <brianvv@google.com>
Subject: [PATCH 5.10 26/80] bpf: Add schedule points in batch ops
Date:   Mon, 28 Feb 2022 18:24:07 +0100
Message-Id: <20220228172314.737638550@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 75134f16e7dd0007aa474b281935c5f42e79f2c8 upstream.

syzbot reported various soft lockups caused by bpf batch operations.

 INFO: task kworker/1:1:27 blocked for more than 140 seconds.
 INFO: task hung in rcu_barrier

Nothing prevents batch ops to process huge amount of data,
we need to add schedule points in them.

Note that maybe_wait_bpf_programs(map) calls from
generic_map_delete_batch() can be factorized by moving
the call after the loop.

This will be done later in -next tree once we get this fix merged,
unless there is strong opinion doing this optimization sooner.

Fixes: aa2e93b8e58e ("bpf: Add generic support for update and delete batch ops")
Fixes: cb4d03ab499d ("bpf: Add generic support for lookup batch op")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Brian Vazquez <brianvv@google.com>
Link: https://lore.kernel.org/bpf/20220217181902.808742-1-eric.dumazet@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/syscall.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1308,6 +1308,7 @@ int generic_map_delete_batch(struct bpf_
 		maybe_wait_bpf_programs(map);
 		if (err)
 			break;
+		cond_resched();
 	}
 	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
 		err = -EFAULT;
@@ -1365,6 +1366,7 @@ int generic_map_update_batch(struct bpf_
 
 		if (err)
 			break;
+		cond_resched();
 	}
 
 	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
@@ -1462,6 +1464,7 @@ int generic_map_lookup_batch(struct bpf_
 		swap(prev_key, key);
 		retry = MAP_LOOKUP_RETRIES;
 		cp++;
+		cond_resched();
 	}
 
 	if (err == -EFAULT)


