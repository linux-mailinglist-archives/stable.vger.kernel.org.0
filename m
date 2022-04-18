Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F07504FD2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbiDRMRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiDRMRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:17:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAC7DF1F;
        Mon, 18 Apr 2022 05:15:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF0B660F07;
        Mon, 18 Apr 2022 12:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1BAC385A7;
        Mon, 18 Apr 2022 12:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284108;
        bh=qpVTc7+3ifbfoP/oGzLvgbLxeru/ApKNEpfvierqZMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYf8j9aWvqlnS950Atvjn8Gl4ZdqJqXo9yulrddDo7xTtAbKLQTimtouFj0ODAXZH
         a8Vyw1PBw5IiYSezcJiayMkU2VlY+sQNZGsPCOCGToiILS4NSILYlITbcfS4kL6Clh
         CgIgAyYapLMF/oaY9sR45twYGWOqPTwDemXJz1qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.17 002/219] drm/amd/display: Fix p-state allow debug index on dcn31
Date:   Mon, 18 Apr 2022 14:09:31 +0200
Message-Id: <20220418121203.537077401@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 3107e1a7ae088ee94323fe9ab05dbefd65b3077f upstream.

[Why]
It changed since dcn30 but the hubbub31 constructor hasn't been
modified to reflect this.

[How]
Update the value in the constructor to 0x6 so we're checking the right
bits for p-state allow.

It worked before by accident, but can falsely assert 0 depending on HW
state transitions. The most frequent of which appears to be when
all pipes turn off during IGT tests.

Cc: Harry Wentland <harry.wentland@amd.com>

Fixes: e7031d8258f1b4 ("drm/amd/display: Add pstate verification and recovery for DCN31")
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c
@@ -1042,5 +1042,7 @@ void hubbub31_construct(struct dcn20_hub
 	hubbub31->detile_buf_size = det_size_kb * 1024;
 	hubbub31->pixel_chunk_size = pixel_chunk_size_kb * 1024;
 	hubbub31->crb_size_segs = config_return_buffer_size_kb / DCN31_CRB_SEGMENT_SIZE_KB;
+
+	hubbub31->debug_test_index_pstate = 0x6;
 }
 


