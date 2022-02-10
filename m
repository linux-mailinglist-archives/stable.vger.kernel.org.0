Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F9A4B0231
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 02:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbiBJB0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 20:26:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbiBJB0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 20:26:48 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16124201AE
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 17:26:50 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id z62so2442498vsz.2
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 17:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=qdlh4YNnDYW/FiIxb/9VcT8z5m320xDKpRTlU4s3f+k=;
        b=LdGl48fqcOtxXpnqCyX9GyFeRnAvw3/5LeghqJ3nz2yaanZaBhNdmoNKgqn8vR7MWI
         O6V72NpDV4X1H8IsDs8w2HHkGH5Trk185gBo5wdL5n+e0AKWUX/TPhOfrCLuDGxGYAJO
         bIU8xJvLCTXCwE24Lc6bQp3bdnvTZnAYhG/Jw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=qdlh4YNnDYW/FiIxb/9VcT8z5m320xDKpRTlU4s3f+k=;
        b=UD20TU96NexV4vDxKPrg7TLzddLC1TeN8gaT2Ua20Ldb6is5zNo64JCMnfrT/SdJsG
         19c+L/ajKi923KUbSYJdKmSYlRNk9NgceX8x+iu1Nn7UeIaLYGWigUYxsL2usB7JOID6
         EMBdOfI01S5e8k5n2Q8SZ+0GzpVone5D2Pk9lRSLl96E+1zxOL+ougtsklUPCA4ba2zn
         98XvqwL8fSO6OYHAoy1C2j54vbEmmXWx/0HyARZX4dxZ5asWqlQSTCGVOFvnkJHTRm5j
         fOJEeidbU+yLCvCX844Lx+UXz8XTaxHPR35MZOSox+d8rHg9LW3FzSaWmwiOQtbXek+i
         vBSg==
X-Gm-Message-State: AOAM533uv4uhR4l7jlghlFPAbV+1xKWfRQQEU1InXSy6DLuRs7amBoal
        OlkJXwFRID6Jk+B8LwArtBFclH6vdjblhPnameQ+u6onhIpXW1Q1aSPsj1zAllyI3ni0WlE7M16
        /QpsxrWCy6IRDeQ9LpZ6EFupDCIFr5FSy4YGOpupntccHRQewNhlsxCMAHmfvpTSxkuYefrTZEW
        pK9g==
X-Google-Smtp-Source: ABdhPJy8ESqngEbyWO8n+jbFs5AtOjj7eR7XIZXcKtuKCQ8OtLZ7Dcg4rkaObLDuUge9XSMv5xy0kQ==
X-Received: by 2002:a17:902:f610:: with SMTP id n16mr4969250plg.35.1644452246975;
        Wed, 09 Feb 2022 16:17:26 -0800 (PST)
Received: from dev-ushankar.dev.purestorage.com ([192.30.188.252])
        by smtp.gmail.com with ESMTPSA id j7sm19407503pfa.36.2022.02.09.16.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 16:17:26 -0800 (PST)
Date:   Wed, 9 Feb 2022 17:17:21 -0700
From:   Uday Shankar <ushankar@purestorage.com>
To:     stable@vger.kernel.org
Cc:     Prabhath Sajeepa <psajeepa@purestorage.com>,
        linux-nvme@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Uday Shankar <ushankar@purestorage.com>
Subject: Apply "nvme: Fix parsing of ANA log page" to 5.4
Message-ID: <20220210001721.GA151884@dev-ushankar.dev.purestorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Please apply the patch "nvme: Fix parsing of ANA log page" to 5.4.

The commit ID in Linus's tree is:
	64fab7290dc3561729bbc1e35895a517eb2e549e

The patch was originally submitted on the linux-nvme mailing list, but
for reasons unknown to me it never landed on 5.4 - this thread indicates
it should have been accepted for 5.4.
https://lore.kernel.org/linux-nvme/1572303408-37913-1-git-send-email-psajeepa@purestorage.com/T/#u

Without the patch, we perform the check
	WARN_ON_ONCE(offset > ctrl->ana_log_size - sizeof(*desc))
at the end of the enclosing loop. This check only makes sense if we are
about to read another nvme_ana_group_desc from the ana_log_buf, but
that's not the case at the end of the last iteration of the loop. In the
last iteration, the warning fires and the function nvme_parse_ana_log
fails. When nvme native multipath is enabled, this translates into
failure to establish a connection to the controller.

The patch fixes the issue by moving the above check to a correct
position within the loop body.

Thanks,
Uday Shankar
