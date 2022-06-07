Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F311F53F93A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239086AbiFGJPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239070AbiFGJPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:15:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804509A9AB;
        Tue,  7 Jun 2022 02:15:30 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 27E6D21B2F;
        Tue,  7 Jun 2022 09:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654593329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=0LUQ3nifNOW3z3o41f9RjcXFyeDR4z5ozv5oU7KZGjs=;
        b=igk5SUbx/Ct01mlYdRzRFh8eBruXHBb60RssvMesNVjwaN3fndgfXiJRSS6Jpp/xBo4czs
        +CINBEbXVI6PyEIJUXIXxct33LwVi/bSgN53JX57ZW6udp/6UGKzWMWPfdH0BKkfqpCSNv
        ybsSJxhff282zVXeKebnD/PaxHTRGxg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654593329;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=0LUQ3nifNOW3z3o41f9RjcXFyeDR4z5ozv5oU7KZGjs=;
        b=kkquVwQ7kb4EGyV1iQhGk6lPFGl3cmW5kzgwJ/9U0dHCo/BWkmaJgm7UlZo2R2JZqhKwCX
        MMYkvQFQ1RRbI6Cg==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1992B2C142;
        Tue,  7 Jun 2022 09:15:29 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 7523CA0633; Tue,  7 Jun 2022 11:15:28 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        <linux-block@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/6] bfq: cgroup fixes for 5.4 stable
Date:   Tue,  7 Jun 2022 11:15:08 +0200
Message-Id: <20220607091209.24033-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=317; h=from:subject:message-id; bh=uD/ot2HuFiEY1MKFoghAFl9it9B82bR/MiySM2dkcWg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBinxcceKGMKwF+8VIf1b3kSyAUYJ25gVIYuniaLSd2 NwtGxEyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp8XHAAKCRCcnaoHP2RA2bhCB/ 4oDtgKH4SZNYMFeNT160QFAHYlW4tiN95kEUs+GyuVp7C8zuu0sWkqIusVKOYm+BoPsSGbNVE/ghGd a3DlUb22D3iEQ5hgl2bwa0WL1DHZNhO5BT0XTDmQjIjgIGKEeN5n0zk1wL7uaEx3l8xfL8OZHf+3tH j1w6Z/VYJemYjn3LjlOSYMWmsDPsoZ3S8N7dmt998wH+3BgVM5X66v17umqz+9htp05zhE63AyewCx YnjfFtDo4c0XjjOGBJ7I1hG+MwzDDSwvkcvGbJM5w+VKav+ikRgVscZzqTIR9/13EKjUuaucu5Rh5w fRPxO6wuL+eHn2u6QR2Ep2P6CR6G8W
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

In this series are BFQ upstream fixes that didn't apply to 5.4 stable tree
cleanly and needed some massaging before they apply. The result did pass
some cgroup testing with bfq and the backport is based on the one we have
in our SLES kernel so I'm reasonably confident things are fine.

								Honza
