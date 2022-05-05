Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0986C51C320
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 16:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380332AbiEEPCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 11:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236360AbiEEPCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 11:02:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2122F384;
        Thu,  5 May 2022 07:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93DDEB82D7B;
        Thu,  5 May 2022 14:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86188C385A8;
        Thu,  5 May 2022 14:58:27 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="O34exH6/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651762706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KpInDdEYbSbY47RBsSFy57ts9NQcl1oXkKpbt5QwMwo=;
        b=O34exH6/JYvayiHMbbkp9j06B54KTUgRhn4BkyxmGuq6kASQ+pTAsEYwruvN8hg/FCmrqY
        SH7IPkWNsEJ8o0fxsA+26OBcg4WX5UCA6u5/nORvcQYJBwbKFbJGPY6BGVy2VhYbLYIh0+
        qiDSWoKpSa2Co7zl/iUD5bJuw2P55J0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 88f7219e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 5 May 2022 14:58:25 +0000 (UTC)
Date:   Thu, 5 May 2022 16:58:22 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-acpi@vger.kernel.org, stable@vger.kernel.org,
        rafael@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: cache_from_obj: Wrong slab cache. Acpi-Namespace but object is
 from kmalloc-64
Message-ID: <YnPmDlf3KD9ckpM1@zx2c4.com>
References: <YnPkFkZ/S87cHUnP@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YnPkFkZ/S87cHUnP@zx2c4.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey again,

On Thu, May 05, 2022 at 04:50:16PM +0200, Jason A. Donenfeld wrote:
> Hi Rafael,
> 
> I'm seeing the following boot time splat on 5.4.191:

Figured it out. 25928deeb1e4 ("ACPICA: Always create namespace nodes
using acpi_ns_create_node()") needs to be backported to stable.

Jason
