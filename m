Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC37851A9EE
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358004AbiEDRUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358179AbiEDRPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDA356422;
        Wed,  4 May 2022 09:59:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E666AB82737;
        Wed,  4 May 2022 16:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECBBC385A5;
        Wed,  4 May 2022 16:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683563;
        bh=1uPF9iPeVnkugtdDgv3+RKTt3xBCZr5qK5UDqcizsRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nocz6JQgrPRNrDySsJMCrC4fItPrMolqyT1lgWQzz0ZN5sGSXku6Ql05oKAVtkx5J
         GTv8lHkxiDDdykJmsqlM17rvPttXAUKgzTwK4QAnS5LPIZOmlJOUyJqivS6BVCwhNO
         b3PTlCiQM9ofPz4eqyf4yylkQIe1knli8f4e49bY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.17 217/225] tty: n_gsm: fix incorrect UA handling
Date:   Wed,  4 May 2022 18:47:35 +0200
Message-Id: <20220504153129.286283053@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Daniel Starke <daniel.starke@siemens.com>

commit ff9166c623704337bd6fe66fce2838d9768a6634 upstream.

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.4.4.2 states that any received unnumbered
acknowledgment (UA) with its poll/final (PF) bit set to 0 shall be
discarded. Currently, all UA frame are handled in the same way regardless
of the PF bit. This does not comply with the standard.
Remove the UA case in gsm_queue() to process only UA frames with PF bit set
to 1 to abide the standard.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-20-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1865,7 +1865,6 @@ static void gsm_queue(struct gsm_mux *gs
 			}
 		}
 		break;
-	case UA:
 	case UA|PF:
 		if (cr == 0 || dlci == NULL)
 			break;


