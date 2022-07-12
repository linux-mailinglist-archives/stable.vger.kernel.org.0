Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30585571D49
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 16:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiGLOvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 10:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiGLOvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 10:51:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC991B1869;
        Tue, 12 Jul 2022 07:51:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C327B819A6;
        Tue, 12 Jul 2022 14:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF2FC3411C;
        Tue, 12 Jul 2022 14:51:03 +0000 (UTC)
Date:   Tue, 12 Jul 2022 10:51:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <stable@vger.kernel.org>, <tom.zanussi@linux.intel.com>,
        <trix@redhat.com>, <zhangjinhao2@huawei.com>
Subject: Re: [PATCH v2] tracing/histograms: Fix memory leak problem
Message-ID: <20220712105101.49020368@gandalf.local.home>
In-Reply-To: <20220712114844.158722-1-zhengyejian1@huawei.com>
References: <20220711115211.4f613cbe@gandalf.local.home>
        <20220712114844.158722-1-zhengyejian1@huawei.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Jul 2022 19:48:44 +0800
Zheng Yejian <zhengyejian1@huawei.com> wrote:

> Since I'm not very familiar with trace_events_hist.c, I roughly conclude that:
>   1. warning 1/3/6 are plausible but false-positive;
>   2. warning 2/4/5 seems positive although they don't cause practical problems because
> elt_data->field_var_str[i] / ref_field->system / ref_field->name can be 'NULL'
> on 'kfree'. Do we need to explicitly check 'NULL' there?

It's confusing code. Both Tom and I missed it as well.

-- Steve
