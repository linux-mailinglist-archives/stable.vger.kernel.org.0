Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156114F2565
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiDEHtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbiDEHrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7C515FC7;
        Tue,  5 Apr 2022 00:43:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7C6FB81B14;
        Tue,  5 Apr 2022 07:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23839C34112;
        Tue,  5 Apr 2022 07:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144634;
        bh=DIM/edjKr4UZNGGrD7+GnYGqIsFetIGpFlKulOPbLGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJLjoGHH+ECbq7uh7xa29CXNsbAjmp/MNSBkV0AcMfNlxiMSqfxrOHIMb3EiE35FX
         NFHlRpD5cBhJtdqATlP9n4vUlG4BZ2Ew9M2KLzPunNkq51E9qZI0v6JXhuPLvDdEsW
         iA/yn6/grg+h87e4Gayo6wyGjBN/hQiwU+smmGls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.17 0115/1126] dm integrity: set journal entry unused when shrinking device
Date:   Tue,  5 Apr 2022 09:14:22 +0200
Message-Id: <20220405070410.946729795@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit cc09e8a9dec4f0e8299e80a7a2a8e6f54164a10b upstream.

Commit f6f72f32c22c ("dm integrity: don't replay journal data past the
end of the device") skips journal replay if the target sector points
beyond the end of the device. Unfortunatelly, it doesn't set the
journal entry unused, which resulted in this BUG being triggered:
BUG_ON(!journal_entry_is_unused(je))

Fix this by calling journal_entry_set_unused() for this case.

Fixes: f6f72f32c22c ("dm integrity: don't replay journal data past the end of the device")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Milan Broz <gmazyland@gmail.com>
[snitzer: revised header]
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2473,9 +2473,11 @@ static void do_journal_write(struct dm_i
 					dm_integrity_io_error(ic, "invalid sector in journal", -EIO);
 					sec &= ~(sector_t)(ic->sectors_per_block - 1);
 				}
+				if (unlikely(sec >= ic->provided_data_sectors)) {
+					journal_entry_set_unused(je);
+					continue;
+				}
 			}
-			if (unlikely(sec >= ic->provided_data_sectors))
-				continue;
 			get_area_and_offset(ic, sec, &area, &offset);
 			restore_last_bytes(ic, access_journal_data(ic, i, j), je);
 			for (k = j + 1; k < ic->journal_section_entries; k++) {


