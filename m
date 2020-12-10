Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0362D62A3
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392095AbgLJQyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 11:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391042AbgLJOgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:36:52 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Luo Meng <luomeng12@huawei.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 47/54] ASoC: wm_adsp: fix error return code in wm_adsp_load()
Date:   Thu, 10 Dec 2020 15:27:24 +0100
Message-Id: <20201210142604.334613909@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo Meng <luomeng12@huawei.com>

commit 3fba05a2832f93b4d0cd4204f771fdae0d823114 upstream.

Fix to return a negative error code from the error handling case
instead of 0 in function wm_adsp_load(), as done elsewhere in this
function.

Fixes: 170b1e123f38 ("ASoC: wm_adsp: Add support for new Halo core DSPs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Acked-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20201123133839.4073787-1-luomeng12@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm_adsp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1912,6 +1912,7 @@ static int wm_adsp_load(struct wm_adsp *
 			mem = wm_adsp_find_region(dsp, type);
 			if (!mem) {
 				adsp_err(dsp, "No region of type: %x\n", type);
+				ret = -EINVAL;
 				goto out_fw;
 			}
 


