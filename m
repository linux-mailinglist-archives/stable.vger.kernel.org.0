Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D39353CFA8
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345359AbiFCRzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346361AbiFCRvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:51:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A101854BFC;
        Fri,  3 Jun 2022 10:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B4EE604EF;
        Fri,  3 Jun 2022 17:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8A7C385B8;
        Fri,  3 Jun 2022 17:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278468;
        bh=NnEyWjMihEvGC1ycsFdaXgQ+EWmAJe/cwgy1WOjErkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyBYEftoQoio5Z1QwBioYoH6ychr6yVSXGY8SFPwA4FpBep0BSHbrsSB1P41ibZKV
         IMzmMVzn/ic1E4ixT9fU1TJTTiNvrc8WWn2Vhue3IvkPWPrMTf6hpNeypSI1qGlQnn
         W4h8OSeW4y9q72n86EBAp7749JbCET1KWnW5ck7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 42/53] dm stats: add cond_resched when looping over entries
Date:   Fri,  3 Jun 2022 19:43:27 +0200
Message-Id: <20220603173819.944245381@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173818.716010877@linuxfoundation.org>
References: <20220603173818.716010877@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit bfe2b0146c4d0230b68f5c71a64380ff8d361f8b upstream.

dm-stats can be used with a very large number of entries (it is only
limited by 1/4 of total system memory), so add rescheduling points to
the loops that iterate over the entries.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -224,6 +224,7 @@ void dm_stats_cleanup(struct dm_stats *s
 				       atomic_read(&shared->in_flight[READ]),
 				       atomic_read(&shared->in_flight[WRITE]));
 			}
+			cond_resched();
 		}
 		dm_stat_free(&s->rcu_head);
 	}
@@ -313,6 +314,7 @@ static int dm_stats_create(struct dm_sta
 	for (ni = 0; ni < n_entries; ni++) {
 		atomic_set(&s->stat_shared[ni].in_flight[READ], 0);
 		atomic_set(&s->stat_shared[ni].in_flight[WRITE], 0);
+		cond_resched();
 	}
 
 	if (s->n_histogram_entries) {
@@ -325,6 +327,7 @@ static int dm_stats_create(struct dm_sta
 		for (ni = 0; ni < n_entries; ni++) {
 			s->stat_shared[ni].tmp.histogram = hi;
 			hi += s->n_histogram_entries + 1;
+			cond_resched();
 		}
 	}
 
@@ -345,6 +348,7 @@ static int dm_stats_create(struct dm_sta
 			for (ni = 0; ni < n_entries; ni++) {
 				p[ni].histogram = hi;
 				hi += s->n_histogram_entries + 1;
+				cond_resched();
 			}
 		}
 	}
@@ -474,6 +478,7 @@ static int dm_stats_list(struct dm_stats
 			}
 			DMEMIT("\n");
 		}
+		cond_resched();
 	}
 	mutex_unlock(&stats->mutex);
 
@@ -750,6 +755,7 @@ static void __dm_stat_clear(struct dm_st
 				local_irq_enable();
 			}
 		}
+		cond_resched();
 	}
 }
 
@@ -865,6 +871,8 @@ static int dm_stats_print(struct dm_stat
 
 		if (unlikely(sz + 1 >= maxlen))
 			goto buffer_overflow;
+
+		cond_resched();
 	}
 
 	if (clear)


