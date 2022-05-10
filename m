Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872DD521A36
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240703AbiEJNyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244545AbiEJNqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:46:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9219154B22;
        Tue, 10 May 2022 06:31:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0AE4B81DA2;
        Tue, 10 May 2022 13:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9859FC385C9;
        Tue, 10 May 2022 13:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189495;
        bh=yoCwmthqTWLrTpChDssSy8r1GU2Q8VGPcgaoXwsiVu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HT0hUI8WSMwtYXOOLREW6NAP2dMSJC5MeJb6G37ngKMYNeAf3CzLnyUo2R/zfuO7h
         oI7Dlu4Oeqey04Y7MNhDNzonWkLN7roAoEx+Cf5UX8RBabNZjq4LCzo3wzw723A8pP
         CQpU2cGWn6q4tMlxvDYTW+rZFqPlvwxgJ0sXuhio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos Llamas <cmllamas@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 068/135] selftests/net: so_txtime: fix parsing of start time stamp on 32 bit systems
Date:   Tue, 10 May 2022 15:07:30 +0200
Message-Id: <20220510130742.361520300@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 97926d5a847ca1758ad8702ce591e3b05a701e0d upstream.

This patch fixes the parsing of the cmd line supplied start time on 32
bit systems. A "long" on 32 bit systems is only 32 bit wide and cannot
hold a timestamp in nano second resolution.

Fixes: 040806343bb4 ("selftests/net: so_txtime multi-host support")
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20220502094638.1921702-2-mkl@pengutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/so_txtime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -475,7 +475,7 @@ static void parse_opts(int argc, char **
 			cfg_rx = true;
 			break;
 		case 't':
-			cfg_start_time_ns = strtol(optarg, NULL, 0);
+			cfg_start_time_ns = strtoll(optarg, NULL, 0);
 			break;
 		case 'm':
 			cfg_mark = strtol(optarg, NULL, 0);


