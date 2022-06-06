Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA6A53ED56
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiFFR5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 13:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiFFR5E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 13:57:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1124A2F9ADF;
        Mon,  6 Jun 2022 10:57:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E8E401FAB3;
        Mon,  6 Jun 2022 17:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654538220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=vKLYD5u4YqoPpkvV/3Sb9uOW0vwc875iEzppuq9XwIA=;
        b=yLjZHy4sdvzy3v6itdPqHUhc4HoPVjtLyvx2N8rVnN4pzZNYRZmCVyGoPhP8Bv+29f3izL
        UyB7eZHTQw2rg6GUKg+KpTwfwshPncqz9BiMzNOi90P9A9QpismPaKKbw8jTBPrInghw+w
        yo6Y6yIW6bc+69XqMKzvED5ISJ9/v/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654538220;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=vKLYD5u4YqoPpkvV/3Sb9uOW0vwc875iEzppuq9XwIA=;
        b=sU3RGELlHCEk09aol+bNsZ1rNBaCDQzi4I4KoNKFM9eapzxXpen2sO3sa6I9hbaY1NKGHs
        5FLKaAMS7WEAJ9Cw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D81DD2C141;
        Mon,  6 Jun 2022 17:57:00 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 0A20FA0633; Mon,  6 Jun 2022 19:56:55 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     <linux-block@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/6] bfq: cgroup fixes for 5.10 stable
Date:   Mon,  6 Jun 2022 19:56:35 +0200
Message-Id: <20220606174118.10992-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=318; h=from:subject:message-id; bh=fcjdrDEqihdijZPTg8CbOwOjJXW79hYAAlpEmDo6cSw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBinj/LaWXCtAgvI3rOruCM+TWT12gkB5k7zbcLH4fu QDBWX0OJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp4/ywAKCRCcnaoHP2RA2eKqCA DBFIHBlr+uQZAhR11azuDl/lxd+9X2sOTe2j8yY8TUYjDv2Q/KRS6PBdEr/i92i/VB9/2+D3nWKUeN Gc1bDTmozg1NTNVtB2fFUIDQd4HW4CPWHt66ltiOsNTX6UkoObLVN/el108m99V8m4hcWfAlfHIVcH GW3u8HNvWaD65subIqR01pxw6zsVy2Ub1n9Dh52QQz2ltHpvaDruFPg0rGovvi0AkOAuWjLi8AIBK0 3wjPxH2/iqUOWQofcDkRTlKmuGwLG5cBn9e6UfUGsqcWnvYryeWDyk9qY3XsYnEKstBC8jpVUdvQhM /UvgT6JFm2XFSvQLnnjhXOjBHJ6RDb
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

In this series are BFQ upstream fixes that didn't apply to 5.10 stable tree
cleanly and needed some massaging before they apply. The result did pass
some cgroup testing with bfq and the backport is based on the one we have
in our SLES kernel so I'm reasonably confident things are fine.

								Honza
